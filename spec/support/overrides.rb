# frozen_string_literal: true

RSpec.shared_context 'with custom generated attribute' do
  require 'rails/override/generators/generated_attribute'
  Rails::Generators::GeneratedAttribute
    .singleton_class
    .prepend(Rails::Override::Generators::GeneratedAttribute)
  Rails::Generators::GeneratedAttribute
    .prepend(Rails::Override::Generators::GeneratedAttribute)
end
