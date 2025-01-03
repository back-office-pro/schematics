# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Configuration do
  include Schematics::Specs::Request

  after do
    ActiveStorage::Blob.service = ActiveStorage::Blob.services.fetch(:test)
  end
end
