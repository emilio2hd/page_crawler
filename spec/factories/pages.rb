FactoryGirl.define do
  factory :page, class: Page do
    source { FFaker::Internet.http_url }
    content { "#{FFaker::Lorem.paragraph}\n#{FFaker::Internet.http_url}\n" }
    status 'processed'

    factory :page_without_content, class: Page do
      source { FFaker::Internet.http_url }
      status 'not_processed'
      content { '' }
    end
  end
end
