# frozen_string_literal: true

require 'active_support/concern'

module Schematics
  module Specs
    module Model # rubocop:disable Metrics/ModuleLength
      extend ActiveSupport::Concern

      included do
        delegate :entity_fixtures, to: :class

        fixtures :all

        subject(:model) { __send__(entity_fixtures, :one) }

        it { is_expected.to be_valid }
        it { is_expected.to have_implicit_order_column(:created_at) }

        attributes.select(&:required?).each do |attribute|
          it { is_expected.to validate_presence_of(attribute.name.to_sym) }
        end

        attributes.select(&:unique?).each do |attribute|
          it { is_expected.to have_db_index(attribute.name.to_sym).unique }
          it do
            is_expected
              .to validate_uniqueness_of(attribute.name.to_sym)
              .ignoring_case_sensitivity
          end
        end

        enum_attributes.each do |attribute|
          it do
            is_expected
              .to define_enum_for(attribute.name.to_sym)
              .with_values(attribute.values)
              .with_prefix
          end
        end

        token_attributes.each do |attribute|
          it { is_expected.to have_secure_token(attribute.name.to_sym) }
          it do
            is_expected
              .to have_db_column(attribute.column_name.to_sym)
              .of_type(:string)
              .with_options(attribute.options_for_migration)
          end
        end

        digest_attributes.each do |attribute|
          it { is_expected.to have_secure_password(attribute.name.to_sym) }
          it do
            is_expected
              .to have_db_column(:"#{attribute.column_name}_digest")
              .of_type(:string)
              .with_options(attribute.options_for_migration)
          end
        end

        float_attributes.each do |attribute|
          it do
            is_expected
              .to validate_numericality_of(attribute.name.to_sym)
                .tap { _1.allow_nil unless attribute.required? }
          end
        end

        integer_attributes.each do |attribute|
          it { is_expected.to validate_numericality_of(attribute.name.to_sym).only_integer }
        end

        attachment_attributes.reject_is_a?(Attributes::Attachments).each do |attribute|
          it { is_expected.to have_one_attached(attribute.name.to_sym) }
        end

        attachments_attributes.each do |attribute|
          it { is_expected.to have_many_attached(attribute.name.to_sym) }
        end

        association_attributes.each do |attribute|
          it do
            is_expected
              .to belong_to(attribute.name.to_sym)
                .class_name(attribute.class_name)
                .with_foreign_key(attribute.column_name)
                .inverse_of(attribute.inverse_association.name.to_sym)
                .counter_cache(:"#{attribute.inverse_association_name.pluralize}_count")
                .tap { _1.optional unless attribute.required? }
          end
          it do
            is_expected
              .to have_db_column(attribute.column_name.to_sym)
              .of_type(:uuid)
          end
        end

        renderable_attributes.reject_is_a?(Behaviours::Preloadable).each do |attribute|
          it { is_expected.to have_db_index(attribute.name.to_sym) }
          it do
            is_expected
              .to have_db_column(attribute.column_name.to_sym)
              .of_type(attribute.type.to_sym)
              .with_options(attribute.options_for_migration)
          end
        end

        database_attributes.each do |attribute|
          it do
            is_expected
              .to have_db_column(attribute.column_name.to_sym)
              .of_type(attribute.type.to_sym)
          end
        end

        virtuals.each do |virtual|
          it { is_expected.to respond_to(virtual.name.to_sym) }
        end

        has_many_associations.each do |association|
          it do
            is_expected
              .to have_many(association.name.to_sym)
              .class_name(association.class_name)
              .with_foreign_key(association.column_name)
              .inverse_of(association.inverse_of.to_sym)
              .dependent(association.required? ? :destroy : :nullify)
          end
        end

        has_one_associations.each do |association|
          it do
            is_expected
              .to have_one(association.name.to_sym)
              .class_name(association.class_name)
              .with_foreign_key(association.column_name)
              .inverse_of(association.inverse_of.to_sym)
          end
        end

        has_many_through_associations.each do |association|
          it do
            is_expected
              .to have_many(association.name.to_sym)
              .class_name(association.class_name)
              .with_foreign_key(association.column_name)
              .through(association.through.name.to_sym)
              .source(association.source.to_sym)
          end
        end

        has_one_through_associations.each do |association|
          it do
            is_expected
              .to have_one(association.name.to_sym)
              .class_name(association.class_name)
              .with_foreign_key(association.column_name)
              .through(association.through.name.to_sym)
              .source(association.source.to_sym)
          end
        end

        has_and_belongs_to_many_associations.each do |association|
          it { is_expected.to have_and_belong_to_many(association.name.to_sym) }
        end
      end

      class_methods do
        delegate :entity, to: :model_class, private: true
        delegate :virtuals,
                 :attributes,
                 :enum_attributes,
                 :token_attributes,
                 :digest_attributes,
                 :float_attributes,
                 :integer_attributes,
                 :attachment_attributes,
                 :attachments_attributes,
                 :association_attributes,
                 :renderable_attributes,
                 :has_many_associations,
                 :has_one_associations,
                 :has_many_through_associations,
                 :has_one_through_associations,
                 :has_and_belongs_to_many_associations,
                 to: :entity,
                 private: true

        def model_class
          name.demodulize.split('_').first.constantize
        end

        def entity_fixtures
          entity.name.pluralize.to_sym
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
