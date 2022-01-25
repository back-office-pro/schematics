# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/generated_attribute'
require 'rails/generators/active_record/migration/migration_generator'
require 'active_record/migration'
require 'active_record/connection_adapters/abstract/schema_definitions'
require 'open_api/router'

GeneratedAttribute = Schematics::Patches::Rails::Generators::GeneratedAttribute
MigrationGenerator = Schematics::Patches::ActiveRecord::Generators::MigrationGenerator
TableDefinition = Schematics::Patches::ActiveRecord::ConnectionAdapters::TableDefinition

Rails::Generators::GeneratedAttribute.singleton_class.prepend(GeneratedAttribute)
Rails::Generators::GeneratedAttribute.prepend(GeneratedAttribute)

ActiveRecord::Generators::MigrationGenerator.prepend(MigrationGenerator)
ActiveRecord::ConnectionAdapters::TableDefinition.prepend(TableDefinition)
ActiveRecord::Migration.define_method(:disable_ddl_transaction) { true }

OpenApi::Router.singleton_class.prepend(Schematics::Patches::OpenApi::Router)

Rails.configuration.to_prepare do
  ImportsController.prepend(Schematics::ImportsController) if defined?(ImportsController)

  if defined?(User)
    User.class_eval do
      after_create do
        regenerate_password_reset_token
        Schematics::UserMailer.new_account(self).deliver_later
      end
    end
  end

  if defined?(Search)
    Search.class_eval do
      belongs_to :user
    end
  end

  if defined?(Setting)
    Setting.class_eval do
      after_update { system('rake assets:clobber') if theme_color_previously_changed? }
    end
  end

  ActiveStorage.singleton_class.module_eval do
    def use_relative_model_naming?
      false
    end
  end
end

ActiveSupport.on_load(:active_storage_record) do
  ActiveStorage::Record.class_eval do
    include Schematics::Loadable
    loadable concerns: [Schematics::Elasticsearchable, Schematics::SoftDeletable]
  end
end

ActiveSupport.on_load(:action_text_rich_text) do
  ActionText::RichText.class_eval do
    acts_as_paranoid
  end
end
