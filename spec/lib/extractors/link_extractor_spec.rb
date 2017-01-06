require 'rails_helper'

describe Extractors::LinkExtractor do
  before do
    @html_doc = Nokogiri::HTML.parse(<<-eohtml)
<html>
  <body>
    <h1 id="tips">This is an awesome document</h1>
    <p>
      I am a paragraph
      <a href="http://google.ca">http normal link</a>
      <a href="https://google.ca">https normal link</a>
      <a href="ftp://test.com/file.txt">Link for ftp file</a>
      <a href="#tips">Go to awesome section</a>
      <a href="html_tips.html#tips">Visit the Useful Tips Section</a>
      <a href="/html/default.asp">HTML tutorial</a>
      <a href="default.asp">HTML tutorial</a>
    </p>
  </body>
</html>
eohtml
  end
  describe '.extract' do
    context 'With some links' do
      it 'should return a list of only url from href' do
        content = subject.extract(@html_doc)

        expect(content).not_to be_empty
        expect(content.size).to eq(2)
        expect(content).to include('http://google.ca', 'https://google.ca')
      end
    end

    context 'With no links' do
      before { @html_doc = Nokogiri::HTML.parse('<html><body><p>I am a paragraph</p></body></html>') }

      it 'should return an empty list' do
        content = subject.extract(@html_doc)
        expect(content).to be_empty
      end
    end
  end
end