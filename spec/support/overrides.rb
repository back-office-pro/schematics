# frozen_string_literal: true

RSpec.shared_context 'with custom generated attribute' do
  Rails::Generators::GeneratedAttribute
    .singleton_class
    .prepend(Schematics::Patches::Rails::Generators::GeneratedAttribute)
  Rails::Generators::GeneratedAttribute
    .prepend(Schematics::Patches::Rails::Generators::GeneratedAttribute)
end
