# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Search, except: %i[index create] do
  include Schematics::Specs::Request
end
