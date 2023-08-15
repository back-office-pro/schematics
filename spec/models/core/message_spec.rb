# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message do
  include Schematics::Specs::Model

  its(:mentions) { is_expected.to be_empty }
end
