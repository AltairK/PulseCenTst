class PagesController < ApplicationController
  # before_filter :find_base_page, :except => [:add_root, :create_root] # find base page for actions
  rescue_from ActiveRecord::RecordNotFound, :with => :page_not_found

  def show
  end

  def edit
  end

  def add_root
  end

  def add
  end

  def create
    @page = @base_page.children.new(params[:page])
    if @page.save
      respond_to do |f|
        f.html { redirect_to show_path(@page.path) }
      end
    else
      respond_to do |f|
        f.html { render :add }
      end
    end
  end

  def create_root
    @page = Page.new(params[:page])
    if @page.save
      respond_to do |f|
        f.html { redirect_to show_path(@page.path) }
      end
    else
      respond_to do |f|
        f.html { render :add_root }
      end
    end
  end

  private

    # find base page for actions
    #
    # @return [Page] return page if it found and raised call page_not_found overwise
    def find_base_page
      @base_page = Page.find_by_path(params[:path])
    end

    def page_not_found
      if Page.root
        redirect_to root_path, error: I18n.t('page_not_found')
      else
        redirect_to add_root_path, error: "#{I18n.t('page_not_found')}\n#{I18n.t('try_add_root_page')}"
      end
    end
end
