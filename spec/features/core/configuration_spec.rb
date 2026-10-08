# frozen_string_literal: true

require 'rails_helper'
require 'capybara/rspec'

RSpec.describe Configuration do
  include Schematics::Specs::Feature

  include_context 'with aws stub'

  after do
    ActiveStorage::Blob.service = ActiveStorage::Blob.services.fetch(:test)
    Rails.configuration.action_mailer.delivery_method = :test
  end
end
