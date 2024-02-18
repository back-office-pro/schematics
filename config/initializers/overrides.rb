# frozen_string_literal: true

require 'active_record/connection_adapters/abstract/schema_definitions'
require 'active_record/override/connection_adapters/table_definition'
require 'active_record/override/generators/migration_generator'
require 'active_storage/service/tenant_s3_service'
require 'active_support/dependencies'
require 'arel/override/predications'
require 'chartkick/override/chartkick'
require 'onelogin/override/ruby-saml/settings'
require 'onelogin/ruby-saml/settings'
require 'open_api/override/router'
require 'open_api/router'
require 'puma/configuration'
require 'puma/override/configuration'
require 'rails/generators'
require 'rails/generators/active_record/migration/migration_generator'
require 'rails/generators/generated_attribute'
require 'rails/override/generators/generated_attribute'
require 'sassc/override/engine'
require 'sidekiq/override/batch'

GeneratedAttribute = Rails::Override::Generators::GeneratedAttribute
MigrationGenerator = ActiveRecord::Override::Generators::MigrationGenerator
TableDefinition = ActiveRecord::Override::ConnectionAdapters::TableDefinition

Rails::Generators::GeneratedAttribute.singleton_class.prepend(GeneratedAttribute)
Rails::Generators::GeneratedAttribute.prepend(GeneratedAttribute)

ActiveRecord::Generators::MigrationGenerator.prepend(MigrationGenerator)
ActiveRecord::ConnectionAdapters::TableDefinition.prepend(TableDefinition)

OpenApi::Router.singleton_class.prepend(OpenApi::Override::Router)
Chartkick.singleton_class.prepend(Chartkick::Override)

Sidekiq::Batch.singleton_class.prepend(Sidekiq::Override::Batch)
Sidekiq::Batch.prepend(Sidekiq::Override::Batch)

Puma::Configuration.prepend(Puma::Override::Configuration)
OneLogin::RubySaml::Settings.prepend(OneLogin::Override::RubySaml::Settings)
Arel::Predications.prepend(Arel::Override::Predications)
SassC::Engine.prepend(SassC::Override::Engine)

Rails.configuration.to_prepare do
  ActiveStorage.singleton_class.module_eval do
    def use_relative_model_naming? = false
  end
  ActionText::Attachable.class_eval do
    def as_json(*)
      super
    end
  end
  ActiveModel::OneTimePassword::InstanceMethodsOnActivation.class_eval do
    def serializable_hash(*)
      super
    end
  end
end

Rails.configuration.to_prepare do
  require 'mobility/backends/action_text'
  require 'mobility/backends/active_record/key_value'
  require 'mobility/override/backends/active_record/key_value'

  Mobility::Backends::ActionText::RichTextTranslation.include(Schematics::SoftDeletable)
  Mobility::Backends::ActionText::PlainTextTranslation.include(Schematics::SoftDeletable)
  Mobility::Backends::ActiveRecord::KeyValue::StringTranslation.include(Schematics::SoftDeletable)
  Mobility::Backends::ActiveRecord::KeyValue::TextTranslation.include(Schematics::SoftDeletable)
  Mobility::Backends::ActiveRecord::KeyValue
    .singleton_class
    .prepend(Mobility::Override::Backends::ActiveRecord::KeyValue)
end

Rails.configuration.to_prepare do
  FriendlyId::Slug.include(Schematics::SoftDeletable)
end

ActiveSupport.on_load(:active_storage_record) do
  self.implicit_order_column = 'created_at'

  include Schematics::Loadable
  include Schematics::Serializable
  include Schematics::Shortenable
  include Schematics::Translatable

  loadable concerns: [Schematics::SoftDeletable]

  scope :with_string_translations, -> { self }
  scope :with_slugs, -> { self }

  class << self
    alias_method :finder, :find
  end

  def versions = Schematics::Version.none
end

ActiveSupport.on_load(:active_storage_blob) do
  include Tenant.search_engine.concern
end

ActiveSupport.on_load(:action_text_rich_text) do
  require 'mobility/action_text'

  include Schematics::SoftDeletable

  class << self
    def ransackable_attributes(*)
      ['body']
    end
  end
end

ActiveSupport.on_load(:solid_cache_entry) do
  encrypts :value
end
