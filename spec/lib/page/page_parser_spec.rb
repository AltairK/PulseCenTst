require 'spec_helper'
require 'rails_helper'

describe PageParser do
  let(:bold_text) { '**[string]**' }
  let(:slash_text) { '\\[string]\\' }
  let(:link_text) { '((name1/name2/name3 [string]))' }

  describe '::to_html' do
    it { expect(PageParser.to_html(bold_text)) == '<b>[string]</b>' }
    it { expect(PageParser.to_html(slash_text)) == '<i>[string]</i>' }
    it { expect(PageParser.to_html(link_text)) == '<a href="/name1/name2/name3">[string]</a>' }
  end
end
