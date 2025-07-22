# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'
require 'capybara/rspec'

SchemaCache.model_classes.each do |model_class|
  RSpec.describe model_class, type: :feature do
    include Schematics::Specs::Feature
  end
end
