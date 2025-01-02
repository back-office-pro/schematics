# frozen_string_literal: true

require_relative "#{Dir.pwd}/config/environment"
require 'capybara/rspec'

Tenant.model_classes.each do
  RSpec.describe it, type: :feature do
    include Schematics::Specs::Feature
  end
end
