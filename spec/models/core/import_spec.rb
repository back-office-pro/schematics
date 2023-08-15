# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Import do
  include Schematics::Specs::Model

  its(:model_class) { is_expected.to eq(User) }
end
