# frozen_string_literal: true

require 'active_support/concern'

module Schematics
  module Specs
    module Model # rubocop:disable Metrics/ModuleLength
      extend ActiveSupport::Concern

      included do
        delegate :entity_fixtures, to: :class
        fixtures :all

        subject(:record) { __send__(entity_fixtures, :one) }

        it { is_expected.to be_valid }
        it { is_expected.to have_implicit_order_column(:created_at) }
        it { is_expected.to be_a(Loadable) }

        triggers.each do |trigger|
          it { is_expected.to respond_to(trigger.method_name.to_sym) }
          it { is_expected.to callback(trigger.method_name.to_sym).after(trigger.action.to_sym) }
        end

        attributes
          .select(&:required?)
          .reject_is_a?(Attributes::StateMachine)
          .each do |attribute|
            it { is_expected.to validate_presence_of(attribute.name.to_sym) }
          end

        attributes
          .select(&:unique?)
          .each do |attribute|
            it { is_expected.to have_db_index(attribute.name.to_sym).unique }
            it do
              is_expected
                .to validate_uniqueness_of(attribute.name.to_sym)
                  .tap { _1.case_insensitive unless attribute.case_sensitive? }
                  .tap { _1.allow_nil unless attribute.required? }
            end
          end

        fillable_attributes
          .select(&:readonly?)
          .each do |attribute|
            it { is_expected.to have_readonly_attribute(attribute.name.to_sym) }
          end

        enumerable_attributes.each do |attribute|
          it do
            is_expected
              .to validates_inclusion_of(attribute.name.to_sym)
                .in(attribute.values)
                .tap { _1.allow_nil unless attribute.required? }
          end
        end

        numerable_attributes.each do |attribute|
          it do
            is_expected
              .to validate_numericality_of(attribute.name.to_sym)
                .tap { _1.allow_nil unless attribute.required? }
          end
        end

        fillable_attributes
          .reject_is_a?(Behaviours::Preloadable)
          .each do |attribute|
            it do
              is_expected.to allow_value('').for(attribute.name.to_sym) if attribute.allow_blank
              is_expected.to allow_value(attribute.default).for(attribute.name.to_sym)
            end
          end

        renderable_attributes
          .reject_is_a?(Behaviours::Preloadable)
          .each do |attribute|
            it { is_expected.to have_db_index(attribute.name.to_sym) }
            it do
              is_expected
                .to have_db_column(attribute.column_name.to_sym)
                .of_type(attribute.database_type.to_sym)
                .with_options(attribute.options_for_migration)
            end
          end

        attachments_attributes.each do |attribute|
          it do
            is_expected
              .to accept_nested_attributes_for(attribute.association_name)
              .allow_destroy(true)
            is_expected.to validate_attached_of(attribute.name.to_sym) if attribute.required?
            is_expected
              .to validate_size_of(attribute.name.to_sym)
                .tap { _1.less_than(attribute.options.size.megabytes) if attribute.options.size }
            is_expected
              .to validate_dimensions_of(attribute.name.to_sym)
                .tap { _1.width(attribute.options.width) if attribute.options.width }
            is_expected
              .to validate_dimensions_of(attribute.name.to_sym)
                .tap { _1.height(attribute.options.height) if attribute.options.height }
          end
        end

        string_attributes do |attribute|
          it do
            is_expected
              .to validate_length_of(attribute.name.to_sym)
                .tap { _1.is_at_least(attribute.options.min) if attribute.options.min }
                .tap { _1.is_at_most(attribute.options.limit) if attribute.options.limit }
                .tap { _1.is_equal_to(attribute.options.length) if attribute.options.length }
          end
        end

        database_attributes.each do |attribute|
          it do
            is_expected
              .to have_db_column(attribute.column_name.to_sym)
              .of_type(attribute.database_type.to_sym)
          end
        end

        elements.each do |element|
          it do
            case element
            when Attributes::Url
              is_expected.to validate_url_of(element.name.to_sym)
            when Attributes::Decimal
              is_expected
                .to validate_numericality_of(element.name.to_sym)
                  .tap { _1.is_less_than(element.bound) if element.precision }
                  .tap { _1.is_greater_than(-element.bound) if element.precision }
            when Attributes::Integer
              is_expected.to validate_numericality_of(element.name.to_sym).only_integer
            when Attributes::Enum
              is_expected
                .to define_enum_for(element.name.to_sym)
                .with_values(element.values)
                .with_prefix
            when Attributes::RichText
              # TODO: wait for have_encrypted_rich_text
              is_expected.to have_rich_text(element.name.to_sym)
            when Attributes::Digest
              is_expected.to have_secure_password(element.name.to_sym)
              is_expected
                .to have_db_column(:"#{element.column_name}_digest")
                .of_type(:string)
                .with_options(element.options_for_migration)
              is_expected.to validate_confirmation_of(element.name.to_sym) if element.confirm?
              is_expected
                .to validate_length_of(element.name.to_sym)
                  .tap { _1.is_at_least(element.options.min) if element.options.min }
              is_expected
                .to validate_length_of(element.name.to_sym)
                .is_at_most(::ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED)
            when Attributes::Token
              is_expected.to have_secure_token(element.name.to_sym)
              is_expected
                .to have_db_column(element.column_name.to_sym)
                .of_type(:string)
                .with_options(element.options_for_migration)
            when Attributes::Attachments
              is_expected.to have_many_attached(element.name.to_sym)
            when Attributes::Attachment
              is_expected.to have_one_attached(element.name.to_sym)
            when Attributes::StateMachineEvent
              is_expected.to respond_to(:"after_#{element.name}")
              is_expected.to callback(:"after_#{element.name}").after(element.name.to_sym)
            when Attributes::Association
              is_expected
                .to belong_to(element.name.to_sym)
                  .class_name(element.class_name)
                  .with_foreign_key(element.column_name)
                  .inverse_of(element.inverse_association.name.to_sym)
                  .counter_cache(:"#{element.inverse_association_name.pluralize}_count")
                  .tap { _1.optional unless element.required? }
              is_expected
                .to have_db_column(element.column_name.to_sym)
                .of_type(:uuid)
            when Virtuals::Virtual
              is_expected.to respond_to(element.name.to_sym)
            when Associations::HasAndBelongsToMany
              is_expected.to have_and_belong_to_many(element.name.to_sym)
            when Associations::HasManyThrough
              is_expected
                .to have_many(element.name.to_sym)
                .class_name(element.class_name)
                .with_foreign_key(element.column_name)
                .through(element.through.name.to_sym)
                .source(element.source.to_sym)
            when Associations::HasMany
              is_expected
                .to have_many(element.name.to_sym)
                .class_name(element.class_name)
                .with_foreign_key(element.column_name)
                .inverse_of(element.inverse_of.to_sym)
                .dependent(element.required? ? :destroy : :nullify)
            when Associations::HasOne
              is_expected
                .to have_one(element.name.to_sym)
                .class_name(element.class_name)
                .with_foreign_key(element.column_name)
                .inverse_of(element.inverse_of.to_sym)
            when Associations::HasOneThrough
              is_expected
                .to have_one(element.name.to_sym)
                .class_name(element.class_name)
                .with_foreign_key(element.column_name)
                .through(element.through.name.to_sym)
                .source(element.source.to_sym)
            end
          end
        end
      end

      class_methods do
        delegate :entity, to: :model_class
        delegate :elements,
                 :attributes,
                 :triggers,
                 :renderable_attributes,
                 :fillable_attributes,
                 :attachments_attributes,
                 :enumerable_attributes,
                 :numerable_attributes,
                 :string_attributes,
                 to: :entity

        def model_class
          description.constantize
        end

        def entity_fixtures
          entity.table_name.pluralize.to_sym
        end

        def database_attributes
          [
            entity.find_field_by_name('id'),
            entity.find_field_by_name('created_at')
          ]
        end
      end
    end
  end
end
