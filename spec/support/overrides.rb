# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails/override/generators/generated_attribute'

RSpec.shared_context 'with custom generated attribute' do
  Rails::Generators::GeneratedAttribute
    .singleton_class
    .prepend(Rails::Override::Generators::GeneratedAttribute)
  Rails::Generators::GeneratedAttribute
    .prepend(Rails::Override::Generators::GeneratedAttribute)
end
