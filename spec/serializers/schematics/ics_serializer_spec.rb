# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::IcsSerializer do
  subject(:serializer) { described_class.new(meeting) }

  let(:meeting) do
    Meeting.new(start_at: Time.current, end_at: Time.current, subject: 'Work', slug: 'work')
  end

  its(:file) { is_expected.to be_a(String) }
  its(:filename) { is_expected.to eq('meeting-work.ics') }
  its(:extension) { is_expected.to eq(:ics) }
  its(:content_type) { is_expected.to eq('text/calendar') }
end
