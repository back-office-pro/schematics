# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Search, except: %i[index create] do
  include Schematics::Specs::Request
end
