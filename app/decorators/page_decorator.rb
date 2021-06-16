class PageDecorator < Draper::Base
  decorates :page
  decorates_association :children
  decorates_association :parent

  allows :title, :text, :path

  # Generate subpages tree of current page
  #
  # @return [String] tree via <ul></ul> tags
  def subpages_tree
    empty_string = ''.html_safe
    subpages_list = self.children.inject(empty_string) do |tree, subpage|
      tree + h.content_tag(:li, h.link_to(subpage.title, h.show_path(subpage.path)) + subpage.subpages_tree)
    end
    subpages_list.blank? ? empty_string : h.content_tag(:ul, subpages_list)
  end

end
