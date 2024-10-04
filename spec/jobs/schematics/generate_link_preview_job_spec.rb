# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::GenerateLinkPreviewJob do
  let(:url) { 'https://www.anywhere.com' }
  let(:body) do
    <<~HTML
      <html>
        <head>
          <title>Anywhere</title>
          <link rel='icon' href='https://www.anywhere.com/favicon.png' />
        </head>
        <body>
        </body>
      </html>
    HTML
  end

  before { stub_request(:get, url).to_return(body:, status: 200) }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(url) }
        .to have_enqueued_job(described_class)
        .exactly(:once)
        .with(url)
        .on_queue('default')
        .at(:no_wait)
    end
  end

  describe '#perform_now' do
    subject(:perform_now) { described_class.perform_now(url) }

    it 'caches the link preview informations' do
      expect { perform_now }
        .to change { Rails.cache.fetch('link_preview:https://www.anywhere.com') }
        .from(nil)
        .to(title: 'Anywhere', favicon: 'https://www.anywhere.com/favicon.png')
    end
  end
end
