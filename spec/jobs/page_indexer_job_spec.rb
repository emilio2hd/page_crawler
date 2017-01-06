require 'rails_helper'

describe PageIndexerJob, type: :job do
  include ActiveJob::TestHelper
  let(:target_url) { 'http://test.com/test.html' }
  let(:page_id) { 1 }
  subject(:job) { described_class.perform_later(target_url, page_id) }

  it 'queues the job' do
    expect { job }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end

  it 'is in default queue' do
    expect(PageIndexerJob.new.queue_name).to eq('default')
  end

  it 'executes perform' do
    content = FFaker::Lorem.paragraph
    content << "\n#{FFaker::Internet.http_url}\n"

    allow(Extractors::PageExtractor).to receive(:extract).with(target_url).and_return(content)

    expect(Page).to receive(:save_content).with(instance_of(Fixnum), content)
    perform_enqueued_jobs { job }
  end

  context 'When rises a error' do
    let(:error_to_rise) {}

    before do
      allow(Extractors::PageExtractor).to receive(:extract).and_raise(error_to_rise)
    end

    context 'a timeout error' do
      let(:error_to_rise) { Timeout::Error }

      it 'should log the error and config to retry after 5 minutes when timeout error rises' do
        expect(Sidekiq::Logging.logger).to receive(:error)

        perform_enqueued_jobs do
          expect_any_instance_of(PageIndexerJob).to receive(:retry_job).with(wait: 5.minutes, queue: :default)
          job
        end
      end
    end

    context 'another kind of error' do
      let(:error_to_rise) { Errno::ECONNREFUSED }

      it 'should just log the error' do
        expect(Sidekiq::Logging.logger).to receive(:error)
        expect(Page).to receive(:status_error!).with(instance_of(Fixnum))

        perform_enqueued_jobs do
          expect_any_instance_of(PageIndexerJob).not_to receive(:retry_job)
          job
        end
      end
    end
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end
end