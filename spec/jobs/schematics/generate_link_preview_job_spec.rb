# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::GenerateLinkPreviewJob do
  let(:url) { 'https://www.anywhere.com' }
  let(:body) do
    <<~HTML
      <html>
        <head>
          <title>Anywhere</title>
        </head>
        <body>
        </body>
      </html>
    HTML
  end

  before { stub_request(:get, url).to_return(body:, status: 200) }

  it { is_expected.to be_a(Schematics::Quietable) }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(url) }
        .to have_enqueued_job(described_class)
        .exactly(:once)
        .with(url)
        .on_queue('low')
        .at(:no_wait)
    end
  end

  describe '#perform_now' do
    subject(:perform_now) { described_class.perform_now(url) }

    it 'creates the link preview' do
      expect { perform_now }
        .to change(LinkPreview, :count)
        .by(1)
    end
  end
end
