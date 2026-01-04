# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'active_record/override/connection_adapters/sqlite3_adapter'
require 'active_record/override/generators/migration_generator'
require 'active_storage/override/attachment'
require 'active_storage/override/blob'
require 'active_support/dependencies'
require 'arel/override/predications'
require 'bootstrap-email/config'
require 'bootstrap-email/override/config'
require 'omniauth/key_store'
require 'omniauth/override/key_store'
require 'onelogin/override/ruby-saml/settings'
require 'onelogin/ruby-saml/settings'
require 'rails/generators'
require 'rails/generators/active_record/migration/migration_generator'
require 'rails/generators/generated_attribute'
require 'rails/override/generators/generated_attribute'
require 'solid_queue/configuration'
require 'solid_queue/override/configuration'

GeneratedAttribute = Rails::Override::Generators::GeneratedAttribute
MigrationGenerator = ActiveRecord::Override::Generators::MigrationGenerator

Rails::Generators::GeneratedAttribute.singleton_class.prepend(GeneratedAttribute)
Rails::Generators::GeneratedAttribute.prepend(GeneratedAttribute)

ActiveRecord::Generators::MigrationGenerator.prepend(MigrationGenerator)

OneLogin::RubySaml::Settings.prepend(OneLogin::Override::RubySaml::Settings)
OmniAuth::KeyStore.prepend(OmniAuth::Override::KeyStore)
Arel::Predications.prepend(Arel::Override::Predications)
BootstrapEmail::Config.prepend(BootstrapEmail::Override::Config)
SolidQueue::Configuration.prepend(SolidQueue::Override::Configuration)

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
  Turbo::Streams::Broadcasts::ApplicationController = Class.new(ActionController::Base) # rubocop:disable Style/MutableConstant, Rails/ApplicationController
end

ActiveSupport.on_load(:active_storage_record) do
  self.implicit_order_column = 'created_at'

  include Schematics::Loadable
  include Schematics::Serializable
  include Schematics::Identifiable
  include Schematics::Translatable
  include Schematics::Routable

  loadable concerns: [Schematics::SoftDeletable]

  scope :with_string_translations, -> { self }
  scope :with_slugs, -> { self }

  class << self
    alias_method :finder, :find

    def validate_service_configuration(*) = nil
  end

  def paper_trail_versions = Schematics::Version.none
end

ActiveSupport.on_load(:active_storage_attachment) do
  belongs_to :blob,
             -> { with_deleted },
             class_name: 'ActiveStorage::Blob',
             autosave: true,
             inverse_of: :attachments

  after_restore -> { blob&.restore! }

  prepend ActiveStorage::Override::Attachment

  def blob_url = Rails
    .application
    .routes
    .url_helpers
    .rails_blob_url(self, **Configuration.default_url_options)
end

ActiveSupport.on_load(:active_storage_blob) do
  include Schematics::Multisearchable
  include Schematics::Searchable
  prepend ActiveStorage::Override::Blob
end

ActiveSupport.on_load(:action_text_rich_text) do
  require 'mobility/action_text'

  include Schematics::SoftDeletable
  include Schematics::Identifiable

  class << self
    def ransackable_attributes(*)
      ['body']
    end
  end
end

ActiveSupport.on_load(:active_record_sqlite3adapter) do
  prepend ActiveRecord::Override::ConnectionAdapters::SQLite3Adapter

  ActiveRecord::ConnectionAdapters::SQLite3::TableDefinition.class_eval do
    define_column_methods :jsonb
  end
end
