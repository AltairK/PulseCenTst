class Page < ApplicationRecord
  class PathIncorrect < RuntimeError; end

  NAME_MATCH_STR = '[a-zA-Z0-9_]+'
  # PATH_REGEXP = Regexp.new("\A(?:/#{NAME_MATCH_STR})+\Z")

  belongs_to :parent, class_name: :Page, foreign_key: :page_id
  has_many :children, class_name: :Page
  attr_accessible :name, :text, :title
  validates :name,
            uniqueness: { scope: :page_id },
            format: { with: /\A#{NAME_MATCH_STR}\Z/i }
  validate :root_page_is_unique, if: :root?

  def self.find_by_path(path)
    if (page_names = names_from_path(path)).any?
      page_names.inject(root) { |page, page_name| page.children.find_by_name(page_name) }
    else
      root
    end
  end

  def self.root
    where(page_id: nil).first
  end

  def root?
    !parent
  end

  def path
    if root?
      '/'
    else
      page = self
      result_path = "/#{page.name}"
      result_path = "/#{page.name}" + result_path until (page = page.parent).root?
      result_path
    end
  end

  private

  def root_page_is_unique
    errors.add(:page_id, :root_page_is_not_unique) if self.class.exists?(page_id: nil)
  end

  def self.names_from_path(path)
    path.split('/').delete_if(&:blank?)
  end
end
