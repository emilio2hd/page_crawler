require 'rails_helper'

describe Page, type: :model do
  it { is_expected.to validate_presence_of(:source) }

  context 'when invalid source' do
    it { is_expected.not_to allow_value('invalidurl').for(:source) }
  end

  context 'when valid source' do
    it { is_expected.to allow_value('http://google.com').for(:source) }
  end

  describe '.save_content' do
    context 'when there is a previous page' do
      let(:new_content) { FFaker::Lorem.paragraph }

      before do
        @previous_page = create(:page_without_content)
        Page.save_content(@previous_page.id, new_content)
        @previous_page.reload
      end

      it 'should update previous pages content' do
        expect(@previous_page.content).to eq(new_content)
      end

      it 'should update status to processed' do
        expect(@previous_page.status).to eq('processed')
      end
    end
  end

  describe '.status_error!' do
    before { @page = create(:page_without_content) }

    it 'should change the pages status to error' do
      Page.status_error!(@page.id)

      @page.reload

      expect(@page.error?).to be_truthy
    end
  end
end
