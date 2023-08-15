# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Role do
  include Schematics::Specs::Model

  it { is_expected.not_to be_admin }
  its(:permission_ids) { is_expected.to eq(Permission.features.ids) }
end
