require 'uri'

module Extractors
  class LinkExtractor
    LINK_TAG = 'a'.freeze

    def extract(document)
      document.css(LINK_TAG).map { |link| link['href'] if link['href'] =~ URI.regexp(%w(http https)) }.compact
    end
  end
end