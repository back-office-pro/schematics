# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'
require 'capybara/rspec'

RSpec.describe Search, except: :create do
  include Schematics::Specs::Feature
end
