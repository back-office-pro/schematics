# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::GoogleMap::Component, type: :component do
  subject { render_inline described_class.new(address:) }

  let(:address) { '2 Rue Emile Verhaeren' }

  before { Configuration.instance.update!(gcloud_public_api_key: 'test') }

  it { is_expected.to have_css('iframe') }
end
