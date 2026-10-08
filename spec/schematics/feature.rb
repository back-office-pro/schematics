# frozen_string_literal: true

require 'rails_helper'
require 'capybara/rspec'

load_current_schema
Schematics::SchemaCache.model_classes.each do |model_class|
  RSpec.describe model_class, type: :feature do
    include Schematics::Specs::Feature
  end
end
