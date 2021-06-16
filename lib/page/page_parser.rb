#TODO: replace by  ActionController::Caching::Sweeper
module PageParser
  BOLD_REGEXP = Regexp.new('(\*\*(?<text>(?:[^*]|\*(?!\*))+)\*\*)')
  ITALIC_REGEXP = Regexp.new('(\\\\(?<text>(?:[^\\\]|\\(?!\\))+)\\\\)', Regexp::EXTENDED)
  LINK_REGEXP = Regexp.new("(\\(\\((?<path>(?:[#{Page::MATCHED_SYMBOLS}]+\/)*[#{Page::MATCHED_SYMBOLS}]+)\s(?<text>[^()]+)\\)\\))")

  def self.to_html text
    text.gsub(BOLD_REGEXP, '<b>\k<text></b>').
         gsub(ITALIC_REGEXP, '<i>\k<text></i>').
         gsub(LINK_REGEXP, '<a href="/\k<path>">\k<text></a>')
  end
end
