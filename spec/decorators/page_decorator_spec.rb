require 'spec_helper'
require 'rails_helper'

describe PageDecorator do
  let(:root_page) { FactoryBot.create(:root_page) }
  let(:sub1_page) { FactoryBot.create(:sub1_page, parent: root_page) }
  let(:sub1sub1_page) { FactoryBot.create(:sub1sub1_page, parent: sub1_page) }
  let(:sub2_page) { FactoryBot.create(:sub2_page, parent: root_page) }

  subject { PageDecorator.new(root_page) }

  let(:h) { subject.h }

  describe '#title' do
    it { expect(subject.title) == root_page.title }
  end
  describe '#text' do
    it { expect(subject.text) == root_page.text }
  end
  describe '#children_tree' do
    it do
      sub1sub1_link = h.content_tag :li, h.link_to(sub1sub1_page.title, h.show_path(sub1sub1_page.path))
      sub1_link = h.content_tag(:li, h.link_to(sub1_page.title, h.show_path(sub1_page.path)) +
        h.content_tag(:ul, sub1sub1_link))
      sub2_link = h.content_tag :li, h.link_to(sub2_page.title, h.show_path(sub2_page.path))

      expect(subject.subpages_tree) == h.content_tag(:ul, sub1_link + sub2_link)
    end
  end
end
