# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/generated_attribute'
require 'rails/generators/active_record/migration/migration_generator'
require 'active_record/migration'

Rails::Generators::GeneratedAttribute
  .singleton_class
  .prepend(Schematics::Patches::Rails::Generators::GeneratedAttribute)
Rails::Generators::GeneratedAttribute
  .prepend(Schematics::Patches::Rails::Generators::GeneratedAttribute)
ActiveRecord::Generators::MigrationGenerator
  .prepend(Schematics::Patches::ActiveRecord::Generators::MigrationGenerator)
ActiveRecord::Migration.define_method(:disable_ddl_transaction) { true }
