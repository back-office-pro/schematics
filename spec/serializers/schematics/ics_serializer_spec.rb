# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::IcsSerializer do
  subject(:serializer) { described_class.new(user) }

  include_context 'with user'

  its(:file) { is_expected.to be_a(String) }
  its(:filename) { is_expected.to eq('user-doe-john.ics') }
  its(:extension) { is_expected.to eq(:ics) }
  its(:content_type) { is_expected.to eq('text/calendar') }
end
