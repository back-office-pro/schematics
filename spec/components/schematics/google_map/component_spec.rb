# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::GoogleMap::Component, type: :component do
  subject { render_inline described_class.new(address:) }

  let(:address) { '2 Rue Emile Verhaeren' }

  it { is_expected.to have_selector('iframe') }
end
