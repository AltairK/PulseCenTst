require 'rails_helper'
require 'spec_helper'

RSpec.describe Page, type: :model do
  let(:root_page) { FactoryBot.create(:root_page) }
  let(:another_root_page) { FactoryBot.create(:another_root_page) }
  let(:sub1_page) { FactoryBot.create(:sub1_page, parent: root_page) }
  let(:sub1sub1_page) { FactoryBot.create(:sub1sub1_page, parent: sub1_page) }
  let(:sub2_page) { FactoryBot.create(:sub2_page, parent: root_page) }

  describe '::root' do
    it { expect(root_page) == described_class.root }
  end
  describe '#root?' do
    it { expect(root_page).to be_root }
    it { expect(sub1_page).not_to be_root }
  end
  describe '::find_by_path' do
    it { expect(described_class.find_by_path(root_page.path)) == root_page }
    it { expect(described_class.find_by_path(sub1_page.path)) == sub1_page }
    it { expect(described_class.find_by_path(sub1sub1_page.path)) == sub1sub1_page }
    shared_examples_for 'with not existing page' do
      it { expect { described_class.find_by_path('not/existing/page') }.to raise_error(ActiveRecord::RecordNotFound) }
    end
    context 'with root page' do
      before { root_page }
      it_behaves_like 'with not existing page'
      it { expect(described_class.find_by_path(nil)) == root_page }
    end
    context 'without root page' do
      it_behaves_like 'with not existing page'
    end
  end

  describe '#path' do
    it { expect(root_page.path) == root_page.name }
    it { expect(sub1_page.path) == "#{sub1_page.parent.name}/#{sub1_page.name}" }
    it {
      expect(sub1sub1_page.path) == "#{sub1sub1_page.parent.parent.name}/#{sub1sub1_page.parent.name}/#{sub1sub1_page.name}"
    }
  end

  describe '#subpages' do
    it {
      sub1sub1_page
      sub2_page; expect(root_page.subpages) == [root_page, [[sub1_page, [[sub1sub1_page, []]]], [sub2_page, []]]]
    }
  end
end
