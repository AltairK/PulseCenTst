class PagesController < ApplicationController
  before_action :find_page, except: %i[add_root create_root] # find base page for actions
  before_action :check_root_exists, only: %i[add_root create_root]
  rescue_from ActiveRecord::RecordNotFound, with: :page_not_found

  def show
    @page = PageDecorator.new(@page)
  end

  def edit; end

  def add_root
    @new_page = Page.new
  end

  def add
    @new_page = @page.children.new
  end

  def create
    @new_page = @page.children.new(params[:page])
    if @new_page.save
      respond_to do |f|
        f.html { redirect_to show_path(@new_page.path) }
      end
    else
      respond_to do |f|
        f.html { render :add }
      end
    end
  end

  def create_root
    @new_page = Page.new(params[:page])
    if @new_page.save
      respond_to do |f|
        f.html { redirect_to show_path(@new_page.path) }
      end
    else
      respond_to do |f|
        f.html { render :add_root }
      end
    end
  end

  def update
    if @page.update_attributes(params[:page])
      respond_to do |f|
        f.html { redirect_to show_path(@page.path) }
      end
    else
      respond_to do |f|
        f.html { render :edit }
      end
    end
  end

  private

  # find base page for actions
  #
  # @return [Page] return page if it found and raised call page_not_found overwise
  def find_page
    @page = Page.find_by_path(params[:path])
  end

  def page_not_found
    if Page.root
      redirect_to root_path, error: I18n.t('pages.page_not_found')
    else
      redirect_to add_root_path, error: "#{I18n.t('pages.page_not_found')}\n#{I18n.t('pages.try_add_root_page')}"
    end
  end

  def check_root_exists
    redirect_to root_path, notice: I18n.t('pages.add_root.root_already_exist') if Page.root
  end
end
