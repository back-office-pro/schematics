# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  include Schematics::Specs::Model

  it { is_expected.not_to be_admin }
  it { is_expected.not_to be_online }
end
