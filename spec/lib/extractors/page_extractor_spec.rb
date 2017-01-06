require 'rails_helper'

describe Extractors::PageExtractor do
  let(:url_example) { 'http://www.example.com' }
  let(:page_content) do
<<-eohtml
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
    it 'should return the page content extracted' do
      stub_request(:get, "#{url_example}/").to_return(body: page_content)

      content = described_class.extract(url_example)

      expect(content).not_to be_empty
      expect(content).to include('This is an awesome document', 'http://google.ca', 'https://google.ca')
    end

    context 'With no valid content' do
      let(:empty_page) { '<html><body></body></html>' }

      it 'should return an empty list' do
        stub_request(:get, "#{url_example}/").to_return(body: empty_page)

        content = described_class.extract(url_example)
        expect(content).to be_empty
      end
    end
  end
end