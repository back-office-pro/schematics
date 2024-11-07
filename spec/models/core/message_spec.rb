# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message do
  include Schematics::Specs::Model

  include_context 'with user'

  its(:rich_text_mentions) { is_expected.to be_empty }

  describe '#read?' do
    subject { record.read?(record.author) }

    it { is_expected.to be_falsy }
  end

  describe '#new_reply' do
    subject { record.new_reply }

    it { is_expected.to be_a(described_class) }
    its(:subject) { is_expected.to start_with('RE:') }
  end
end
