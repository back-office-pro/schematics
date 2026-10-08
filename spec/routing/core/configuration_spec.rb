# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Configuration do
  include Schematics::Specs::Routing

  after do
    ActiveStorage::Blob.service = ActiveStorage::Blob.services.fetch(:test)
    Rails.configuration.action_mailer.delivery_method = :test
  end
end
