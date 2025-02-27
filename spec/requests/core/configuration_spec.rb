# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Demo::Configuration do
  include Schematics::Specs::Request

  after do
    ActiveStorage::Blob.service = ActiveStorage::Blob.services.fetch(:test)
  end
end
