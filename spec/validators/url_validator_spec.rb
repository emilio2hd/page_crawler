require 'rails_helper'

describe UrlValidator do
  let(:record) { Page.new }

  subject { described_class.new attributes: { url: '' } }

  context 'invalid input' do
    it 'should be invalid for wrong type of input' do
      subject.validate_each(record, :url, 123456)
      expect(record.errors).to have_key(:url)
    end

    it 'should be invalid for URLs without HTTP or HTTPS protocol' do
      subject.validate_each(record, :url, 'smb://test')
      expect(record.errors).to have_key(:url)
    end

    it 'should be invalid for badly-formed URL' do
      subject.validate_each(record, :url, 'something.com')
      expect(record.errors).to have_key(:url)
    end
  end

  context 'valid input' do
    it 'should be valid for a well-formed HTTP URL' do
      subject.validate_each(record, :url, 'http://some-url.io')
      expect(record.errors).not_to have_key(:url)
    end

    it 'should be valid for a well-formed HTTPS URL' do
      subject.validate_each(record, :url, 'https://google.com')
      expect(record.errors).not_to have_key(:url)
    end
  end
end