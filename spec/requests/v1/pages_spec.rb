require 'rails_helper'

describe 'V1::Pages', type: :request do
  let(:valid_attributes) { { source: FFaker::Internet.http_url } }
  let(:invalid_attributes) { { source: 'invalidurl' } }

  describe 'GET /v1/pages' do
    it 'works! (now write some real specs)' do
      get v1_pages_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /v1/pages/enqueue' do
    context 'with valid params' do
      it 'should enqueue a new url' do
        expect(PageIndexerJob).to receive(:perform_later).with(valid_attributes[:source], instance_of(Fixnum))

        post enqueue_v1_pages_path, params: { page: valid_attributes }

        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid params' do
      before { post enqueue_v1_pages_path, params: { page: invalid_attributes } }

      it 'should not enqueue the url' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'should contains errors in the response body' do
        expect(JSON.parse(response.body)).to have_key('errors')
      end
    end
  end
end
