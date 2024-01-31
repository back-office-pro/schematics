# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Template do
  include Schematics::Specs::Model

  include_context 'with user'

  describe '#interpolate' do
    subject { record.interpolate(user) }

    before { record.content = content }

    context 'when content is well formatted' do
      let(:content) { 'Email: %<email>s' }

      it { is_expected.to eq('Email: john.doe@nowhere.com') }
    end

    context 'when content has an unknown variable' do
      let(:content) { 'Email: %<foo>s' }

      it { is_expected.to eq('foo is not defined') }
    end

    context 'when content has a syntax error' do
      let(:content) { 'Email: %(foo>s' }

      it { is_expected.to eq('malformed format string - %(') }
    end

    context 'when content has HTML tags' do
      let(:content) { "<b>Foo</b><script>alert('ok')></script>" }

      it { is_expected.to eq(content) }
    end
  end
end
