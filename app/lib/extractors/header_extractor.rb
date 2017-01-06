module Extractors
  class HeaderExtractor
    HEADER_TAGS = %w(h1 h2 h3).freeze

    def extract(document)
      HEADER_TAGS.map { |tag| document.css(tag).map(&:content) }.flatten
    end
  end
end
