require 'spec_helper'
require 'rails_helper'

describe PagesHelper do
  describe '#title' do
    it { expect(helper.title) == 'Page' }
    it { assign(:title, 't'); expect(helper.title) == 't' }
  end
end
