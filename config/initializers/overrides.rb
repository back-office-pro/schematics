# frozen_string_literal: true

require 'active_record/connection_adapters/abstract/schema_definitions'
require 'active_record/migration'
require 'active_storage/service/tenant_s3_service'
require 'active_support/dependencies'
require 'active_support/time_with_zone'
require 'open_api/router'
require 'rails/generators'
require 'rails/generators/active_record/migration/migration_generator'
require 'rails/generators/generated_attribute'
require 'view_component/renders_one_form'

GeneratedAttribute = Schematics::Patches::Rails::Generators::GeneratedAttribute
MigrationGenerator = Schematics::Patches::ActiveRecord::Generators::MigrationGenerator
TableDefinition = Schematics::Patches::ActiveRecord::ConnectionAdapters::TableDefinition

Rails::Generators::GeneratedAttribute.singleton_class.prepend(GeneratedAttribute)
Rails::Generators::GeneratedAttribute.prepend(GeneratedAttribute)

ActiveRecord::Generators::MigrationGenerator.prepend(MigrationGenerator)
ActiveRecord::ConnectionAdapters::TableDefinition.prepend(TableDefinition)
ActiveRecord::Migration.define_method(:disable_ddl_transaction) { true }

OpenApi::Router.singleton_class.prepend(Schematics::Patches::OpenApi::Router)

ActiveSupport::TimeWithZone.prepend(Schematics::Patches::ActiveSupport::TimeWithZone)

Rails.configuration.to_prepare do
  Application
    .constants
    .select { Object.const_defined?(_1) }
    .each { Object.const_get(_1).prepend(Application.const_get(_1)) }

  ActiveStorage.singleton_class.module_eval do
    def use_relative_model_naming? = false
  end
end

ActiveSupport.on_load(:active_storage_record) do
  ActiveStorage::Record.class_eval do
    include Schematics::Loadable
    include Schematics::Translatable
    loadable concerns: [Schematics::SoftDeletable]
  end
end

ActiveSupport.on_load(:active_storage_attachment) do
  ActiveStorage::Attachment.class_eval do
    include Schematics::Elasticsearchable
  end
end

ActiveSupport.on_load(:action_text_rich_text) do
  ActionText::RichText.class_eval do
    include Schematics::SoftDeletable
  end
end
