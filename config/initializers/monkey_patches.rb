require 'rails/generators/generated_attribute'
require 'schematics/patches/rails/generators/generated_attribute'

Rails::Generators::GeneratedAttribute
  .singleton_class
  .prepend(Schematics::Patches::Rails::Generators::GeneratedAttribute)
Rails::Generators::GeneratedAttribute
  .prepend(Schematics::Patches::Rails::Generators::GeneratedAttribute)
