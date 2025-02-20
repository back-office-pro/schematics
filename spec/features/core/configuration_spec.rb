# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'
require 'capybara/rspec'

RSpec.describe Configuration do
  include Schematics::Specs::Feature

  after do
    ActiveStorage::Blob.service = ActiveStorage::Blob.services.fetch(:test)
  end
end
