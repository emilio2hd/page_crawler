class Page < ApplicationRecord
  enum status: [:not_processed, :processed, :error]

  validates :source, presence: true, url: true

  scope :previously, -> { order(created_at: 'desc') }

  def self.save_content(page_id, content)
    page = find(page_id)
    page.update(content: content, status: :processed)
  end

  def self.status_error!(page_id)
    find(page_id).error!
  end
end
