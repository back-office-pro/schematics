# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::ICSSerializer do
  subject(:serializer) { described_class.new(resource) }

  include_context 'with user'

  let(:meeting) do
    Meeting.new(start_at: Time.current, end_at: Time.current, subject: 'Work', slug: 'work')
  end

  context 'when resource is calendarable' do
    let(:resource) { meeting }

    its(:content) { is_expected.to be_a(String) }
    its(:filename) { is_expected.to eq('meeting-work.ics') }
    its(:extension) { is_expected.to eq(:ics) }
    its(:content_type) { is_expected.to eq('text/calendar') }
  end

  context 'when resource is not calendarable' do
    let(:resource) { user }

    its(:content) { is_expected.to be_nil }
    its(:filename) { is_expected.to eq('user-doe-john.ics') }
    its(:extension) { is_expected.to eq(:ics) }
    its(:content_type) { is_expected.to eq('text/calendar') }
  end
end
