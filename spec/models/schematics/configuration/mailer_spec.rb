# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::Configuration::Mailer do
  subject(:license) { described_class.new(configuration) }

  let(:configuration) do
    Configuration.new(
      postmark_api_token:,
      mailgun_api_key:,
      mailjet_api_key:,
      mailjet_secret_key:
    )
  end

  context 'when not configured' do
    let(:postmark_api_token) { nil }
    let(:mailgun_api_key) { nil }
    let(:mailjet_api_key) { nil }
    let(:mailjet_secret_key) { nil }

    its(:delivery_method) { is_expected.to eq(:test) }
    its(:settings) { is_expected.to be_empty }
  end

  context 'when postmark is configured' do
    let(:postmark_api_token) { 'test' }
    let(:mailgun_api_key) { nil }
    let(:mailjet_api_key) { nil }
    let(:mailjet_secret_key) { nil }

    its(:delivery_method) { is_expected.to eq(:postmark) }
    its(:settings) { is_expected.to eq(postmark_settings: { api_token: 'test' }) }
  end

  context 'when mailgun is configured' do
    let(:postmark_api_token) { nil }
    let(:mailgun_api_key) { 'test' }
    let(:mailjet_api_key) { nil }
    let(:mailjet_secret_key) { nil }

    its(:delivery_method) { is_expected.to eq(:mailgun) }
    its(:settings) { is_expected.to eq(mailgun_settings: { api_key: 'test' }) }
  end

  context 'when mailjet is configured' do
    let(:postmark_api_token) { nil }
    let(:mailgun_api_key) { nil }
    let(:mailjet_api_key) { 'test' }
    let(:mailjet_secret_key) { 'test' }

    its(:delivery_method) { is_expected.to eq(:mailjet) }
    its(:settings) { is_expected.to eq(mailjet_settings: { api_key: 'test', secret_key: 'test' }) }
  end
end
