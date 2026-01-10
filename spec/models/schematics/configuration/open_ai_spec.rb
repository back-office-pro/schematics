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

RSpec.describe Schematics::Configuration::OpenAI do
  subject { described_class.new(configuration) }

  let(:configuration) do
    Configuration.new(
      chatgpt_access_token:,
      gemini_access_token:,
      deepseek_access_token:
    )
  end

  context 'when not configured' do
    let(:chatgpt_access_token) { nil }
    let(:gemini_access_token) { nil }
    let(:deepseek_access_token) { nil }

    it { is_expected.not_to be_configured }

    its(:access_token) { is_expected.to be_nil }
    its(:uri_base) { is_expected.to be_nil }
    its(:model) { is_expected.to be_nil }
  end

  context 'when openai is configured' do
    let(:chatgpt_access_token) { 'test' }
    let(:gemini_access_token) { nil }
    let(:deepseek_access_token) { nil }

    it { is_expected.to be_configured }

    its(:access_token) { is_expected.to eq('test') }
    its(:uri_base) { is_expected.to eq('https://api.openai.com/') }
    its(:model) { is_expected.to eq('gpt-4o-2024-11-20') }
  end

  context 'when gemini is configured' do
    let(:chatgpt_access_token) { nil }
    let(:gemini_access_token) { 'test' }
    let(:deepseek_access_token) { nil }

    it { is_expected.to be_configured }

    its(:access_token) { is_expected.to eq('test') }
    its(:uri_base) { is_expected.to eq('https://generativelanguage.googleapis.com/v1beta/openai/') }
    its(:model) { is_expected.to eq('gemini-2.5-flash') }
  end

  context 'when deepseek is configured' do
    let(:chatgpt_access_token) { nil }
    let(:gemini_access_token) { nil }
    let(:deepseek_access_token) { 'test' }

    it { is_expected.to be_configured }

    its(:access_token) { is_expected.to eq('test') }
    its(:uri_base) { is_expected.to eq('https://api.deepseek.com/') }
    its(:model) { is_expected.to eq('deepseek-chat') }
  end
end
