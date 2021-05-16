require 'rails/generators'
require 'rails/generators/generated_attribute'
require 'rails/generators/active_record/migration/migration_generator'
require 'schematics/patches/rails/generators/generated_attribute'
require 'schematics/patches/active_record/generators/migration_generator'

Rails::Generators::GeneratedAttribute
  .singleton_class
  .prepend(Schematics::Patches::Rails::Generators::GeneratedAttribute)
Rails::Generators::GeneratedAttribute
  .prepend(Schematics::Patches::Rails::Generators::GeneratedAttribute)
ActiveRecord::Generators::MigrationGenerator
  .prepend(Schematics::Patches::ActiveRecord::Generators::MigrationGenerator)
