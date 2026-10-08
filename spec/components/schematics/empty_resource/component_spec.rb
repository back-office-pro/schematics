# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::EmptyResource::Component, type: :component do
  subject { render_inline described_class.new }

  let(:text) { 'No data available' }

  it { is_expected.to have_css('h5', text:) }
end
