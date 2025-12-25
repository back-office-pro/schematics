# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::LinkPreviews::Parse do
  let(:url) { 'https://www.anywhere.com' }

  before { stub_request(:get, url).to_return(body:, status: 200) }

  describe '.call' do
    subject(:call) { described_class.call(url:) }

    context 'when there is no open graph metadata' do
      let(:body) do
        <<~HTML
          <html>
            <head>
              <title>Anywhere</title>
              <meta name="description" content="Welcome" />
            </head>
            <body>
            </body>
          </html>
        HTML
      end

      it { is_expected.to be_a_success }
      its(:title) { is_expected.to eq('Anywhere') }
      its(:description) { is_expected.to eq('Welcome') }
      its(:image) { is_expected.to be_nil }
    end

    context 'when there are open graph metadata' do
      let(:body) do
        <<~HTML
          <html>
            <head>
              <title>Anywhere</title>
              <meta name="description" content="Welcome" />
              <meta property="og:description" content="Good bye" />
              <meta property="og:title" content="Everywhere" />
              <meta property="og:image" content="https://www.anywhere.com/image.png" />
            </head>
            <body>
            </body>
          </html>
        HTML
      end

      it { is_expected.to be_a_success }
      its(:title) { is_expected.to eq('Everywhere') }
      its(:description) { is_expected.to eq('Good bye') }
      its(:image) { is_expected.to eq('https://www.anywhere.com/image.png') }
    end
  end
end
