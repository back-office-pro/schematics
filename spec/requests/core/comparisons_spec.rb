# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::ComparisonsController, except: :create do
  include Schematics::Specs::Request
end
