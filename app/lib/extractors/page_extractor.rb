require 'open-uri'

module Extractors
  class PageExtractor
    def self.extract(url_source)
      page_doc = Nokogiri::HTML(open(URI.parse(url_source)))
      extractors = [HeaderExtractor.new, LinkExtractor.new]
      extractors.map { |extractor| extractor.extract(page_doc) }.flatten.join("\n")
    end
  end
end
