require 'rails_helper'
require 'spec_helper'

describe PagesController do
  let(:not_existing_path) { 'not/existing/page' }
  shared_examples_for 'with not found page without root' do
    it { should redirect_to(add_root_path) }
  end
  shared_examples_for 'with not found page with root' do
    it { should redirect_to(root_path) }
  end

  describe "GET 'show'" do
    context 'without root' do
      it_behaves_like('with not found page without root') { subject { get :show, params: { path: not_existing_path } } }
    end

    context 'with root' do
      before do
        @root_page = FactoryBot.create(:root_page)
      end
      let(:sub1sub1_page) do
        FactoryBot.create(:sub1sub1_page, parent: FactoryBot.create(:sub1_page, parent: @root_page))
      end
      subject { get :show, params: { path: sub1sub1_page.path } }
      it_behaves_like('with not found page with root') { subject { get :show, params: { path: not_existing_path } } }
      it 'returns http success' do
        expect(subject) == be_success
      end
      it { subject; expect(assigns(:page)).to be_an_instance_of(PageDecorator) }
    end
  end

  describe "GET 'edit'" do
    context 'without root' do
      it_behaves_like('with not found page without root') { subject { get :edit, params: { path: not_existing_path } } }
    end
    context 'with root' do
      before do
        @root_page = FactoryBot.create(:root_page)
      end
      let(:sub1sub1_page) do
        FactoryBot.create(:sub1sub1_page, parent: FactoryBot.create(:sub1_page, parent: @root_page))
      end
      subject { get :edit, params: { path: sub1sub1_page.path } }
      it_behaves_like('with not found page with root') { subject { get :edit, params: { path: not_existing_path } } }
      it 'returns http success' do
        expect(response) == be_success
      end
      it { subject; expect(assigns(:page)).to be_an_instance_of(Page) }
    end
  end

  describe "GET 'add_root'" do
    subject { get :add_root }
    it 'returns http success' do
      expect(subject) == be_success
    end
    it { subject; expect(assigns(:new_page)).to be_a_new(Page) }
    context 'if root already exists' do
      before { FactoryBot.create(:root_page) }
      it { subject; expect(flash[:notice]) == I18n.t('pages.add_root.root_already_exist') }
    end
  end

  describe "GET 'add'" do
    let(:root_page) { FactoryBot.create(:root_page) }
    subject { get :add, params: { path: root_page.path } }
    it 'returns http success' do
      expect(subject) == be_success
    end
    it { subject; expect(assigns(:page)).to be_an_instance_of(Page) }
    it { subject; expect(assigns(:new_page)).to be_a_new(Page) }
  end

  shared_examples_for 'success create POST' do
    it { subject; expect(assigns(:new_page)).to be_an_instance_of(Page) }
    it { subject; expect(assigns(:new_page)).not_to be_a_new(Page) }
    it { expect { subject }.to change(Page, :count).by(1) }
    it 'should redirect to added page' do
      expect(subject).to redirect_to(show_path(assigns(:new_page).path))
    end
  end
  shared_examples_for 'failed create POST' do
    it 'should render add template' do
      expect(render_template('pages/add'))
    end
  end

  describe "POST 'create_root'" do
    let(:correct_attr) { { name: 'name1', title: 'Name1', text: 'name1 text' } }
    context 'with existing root page' do
      it_behaves_like('success create POST') { subject { post :create_root, params: { page: correct_attr } } }
      it_behaves_like('failed create POST') { subject { post :create_root, params: { page: {} } } }
    end
  end

  describe "POST 'create'" do
    let(:correct_attr) { { name: 'name1', title: 'Name1', text: 'name1 text' } }
    context 'with existing root page' do
      let(:root_page) { FactoryBot.create(:root_page) }
      before { root_page }
      subject { post :create, params: { page: correct_attr, path: root_page.path } }
      it { subject; expect(assigns(:page)).to be_an_instance_of(Page) }
      it_behaves_like('success create POST') do
        subject do
          post :create, params: { page: correct_attr, path: root_page.path }
        end
      end
      it_behaves_like('failed create POST') { subject { post :create, page: {}, path: root_page.path } }
    end
  end

  describe "PUT 'update" do
    let(:page) { FactoryBot.create(:root_page) }
    let(:new_attr) { { name: 'name1', title: 'Name1', text: 'name1 text' } }
    context 'success' do
      subject { put :update, params: { path: page.path, page: new_attr } }
      it { subject; expect(assigns(:page)).to be_an_instance_of(Page) }
      it { expect(subject).to redirect_to(show_path(assigns(:page).path)) }
    end
    context 'failed' do
      subject { put :update, params: { path: page.path, page: { name: '' } } }
      it { expect(subject).to render_template('pages/edit') }
      it { subject; expect(assigns(:page)).to be_changed }
    end
  end
end
