require 'rails_helper'

describe V1::PagesController, type: :controller do
  let(:valid_attributes) { { source: FFaker::Internet.http_url } }
  let(:invalid_attributes) { { source: nil } }

  describe 'GET #index' do
    before do
      create_list(:page, 5)

      get :index

      @json_body = JSON.parse(response.body)
    end
    it 'assigns all pages as @pages' do
      expect(@json_body).to have_key('pages')
      expect(@json_body['pages']).to_not be_empty
      expect(@json_body['pages'].size).to eq(5)
    end

    it 'should have pagination meta' do
      expect(@json_body['meta']).to include('current_page' => 1)
      expect(@json_body['meta']).to include('next_page' => nil)
      expect(@json_body['meta']).to include('prev_page' => nil)
      expect(@json_body['meta']).to include('total_pages' => 1)
      expect(@json_body['meta']).to include('total_count' => 5)
    end
  end

  describe 'POST #enqueue' do
    before do
      allow(PageIndexerJob).to receive(:perform_later).with(valid_attributes[:source], instance_of(Fixnum))
    end

    context 'with valid params' do
      it 'should save a new page not processed' do
        expect do
          post :enqueue, params: { page: valid_attributes }
        end.to change { Page.where(status: :not_processed).count }.by(1)
      end

      it 'should enqueue a new PageIndexerJob' do
        expect(PageIndexerJob).to receive(:perform_later).with(valid_attributes[:source], instance_of(Fixnum))

        post :enqueue, params: { page: valid_attributes.except(:content) }
      end

      it 'should get json response' do
        post :enqueue, params: { page: valid_attributes }

        json_body = JSON.parse(response.body)
        expect(json_body).to have_key('msg')
      end

      it 'should get status :created' do
        post :enqueue, params: { page: valid_attributes }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid params' do
      it 'should contains errors in the response body' do
        post :enqueue, params: { page: invalid_attributes }

        response_json = JSON.parse(response.body)

        expect(response_json).to have_key('errors')
        expect(response_json['errors']).to_not be_empty
      end

      it 'should get status :unprocessable_entity' do
        post :enqueue, params: { page: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'should not save a new page' do
        expect { post :enqueue, params: { page: invalid_attributes } }.to_not change(Page, :count)
      end

      it 'should enqueue a new PageIndexerJob' do
        expect(PageIndexerJob).not_to receive(:perform_later)

        post :enqueue, params: { page: invalid_attributes }
      end
    end
  end
end
