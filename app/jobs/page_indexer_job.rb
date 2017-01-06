class PageIndexerJob < ApplicationJob
  queue_as :default

  rescue_from(StandardError) do |exception|
    Sidekiq::Logging.logger.error(exception)

    unless exception.is_a? Timeout::Error
      page_id = arguments[1]
      Page.status_error!(page_id)
    end

    retry_job wait: 5.minutes, queue: :default if exception.is_a? Timeout::Error
  end

  def perform(page_url, page_id)
    content = ::Extractors::PageExtractor.extract(page_url)
    Page.save_content(page_id, content)
  end
end
