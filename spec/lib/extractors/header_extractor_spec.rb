require 'rails_helper'

RSpec.shared_examples 'some example' do
  let(:content) { '' }

  it 'should return an empty list' do
    expect(content).to be_empty
  end
end

describe Extractors::HeaderExtractor do
  before do
    @html_doc = Nokogiri::HTML.parse(<<-eohtml)
<html>
  <body>
    <h1 id="tips">Title h1</h1>
    <p>I am a paragraph
      <a href="#tips">Go to awesome section</a></p>
    <h2>Title h2 [<small>Ahoy!</small>]</h2>
    <p>I am a paragraph too</p>
    <h3><i class="fa fa-user"></i>Title h3</h3>
    <p>I am a paragraph as well</p>
    <h4>Title h4</h4>
    <span>I am a span</span>
  </body>
</html>
eohtml
  end
  describe '.extract' do
    context 'With headers' do
      it 'should return a list of content only from h1, h2 and h3' do
        content = subject.extract(@html_doc)

        expect(content).not_to be_empty
        expect(content.size).to eq(3)
        expect(content).to include('Title h1', 'Title h2 [Ahoy!]', 'Title h3')
      end
    end

    context 'With no headers' do
      before { @html_doc = Nokogiri::HTML.parse('<html><body><p>I am a paragraph</p></body></html>') }

      it 'should return an empty list' do
        content = subject.extract(@html_doc)
        expect(content).to be_empty
      end
    end
  end
end