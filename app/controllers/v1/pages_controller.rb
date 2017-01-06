module V1
  class PagesController < ApplicationController
    include Paginatable

    # GET /pages
    def index
      pages = Page.previously.all.page(params[:page])

      render json: pages, meta: paginate(pages)
    end

    # POST /pages/enqueue
    def enqueue
      page = Page.new(page_params)
      page.status = :not_processed

      if page.save
        PageIndexerJob.perform_later(page.source, page.id)
        render json: { msg: 'Enqueued url' }, status: :created
      else
        render json: { errors: page.errors }, status: :unprocessable_entity
      end
    end

    private

    def page_params
      params.fetch(:page, {}).permit(:source)
    end
  end
end