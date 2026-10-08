# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::SVGSerializer do
  subject(:serializer) { described_class.new(user) }

  include_context 'with user'

  its(:content) { is_expected.to be_a(String) }
  its(:filename) { is_expected.to eq('user-doe-john.svg') }
  its(:extension) { is_expected.to eq(:svg) }
  its(:content_type) { is_expected.to eq('image/svg+xml') }
end
