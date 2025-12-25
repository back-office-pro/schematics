# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'active_support/concern'

module Schematics
  module Specs
    module Model # rubocop:disable Metrics/ModuleLength
      extend ActiveSupport::Concern

      included do
        delegate :default, to: :class

        subject(:record) { default }

        before do
          allow_any_instance_of(ActiveStorageValidations::ContentTypeValidator)
            .to receive(:enable_spoofing_protection?)
            .and_return(false)
        end

        it { is_expected.to be_valid }
        it { is_expected.to be_versioned }
        it { is_expected.to have_implicit_order_column(:created_at) }
        it { is_expected.to be_a(Loadable) }

        triggers.each do |trigger|
          it { is_expected.to respond_to(trigger.method_name) }
          it do
            is_expected.to(
              callback(trigger.method_name)
                .public_send(*trigger.action.split('_'))
                .tap { _1.after(:commit) if trigger.action.start_with?('after') }
            )
          end
        end

        attributes
          .select(&:required?)
          .grep_v(Attributes::StateMachine)
          .each do |attribute|
            it { is_expected.to validate_presence_of(attribute.name.to_sym) }
          end

        attributes
          .select(&:unique?)
          .each do |attribute|
            it { is_expected.to have_db_index(attribute.name.to_sym).unique }
            it do
              is_expected.to(
                validate_uniqueness_of(attribute.name.to_sym)
                  .tap { _1.ignoring_case_sensitivity if attribute.case_insensitive? }
                  .tap { _1.allow_blank unless attribute.required? }
              )
            end
          end

        enumerable_attributes.each do |attribute|
          it do
            is_expected.to(
              validates_inclusion_of(attribute.name.to_sym)
                .in(attribute.values)
                .tap { _1.allow_blank unless attribute.required? }
            )
          end
        end

        numerable_attributes.each do |attribute|
          it do
            is_expected.to(
              validate_numericality_of(attribute.name.to_sym)
                .tap { _1.allow_nil unless attribute.required? }
                .tap { _1.is_equal_to(attribute.equal_to) if attribute.equal_to }
                .tap { _1.is_less_than(attribute.less_than) if attribute.less_than }
                .tap { _1.is_other_than(attribute.other_than) if attribute.other_than }
                .tap { _1.is_greater_than(attribute.greater_than) if attribute.greater_than }
                .tap { _1.is_less_than_or_equal_to(attribute.less_than_or_equal_to) if attribute.less_than_or_equal_to } # rubocop:disable Layout/LineLength
                .tap { _1.is_greater_than_or_equal_to(attribute.greater_than_or_equal_to) if attribute.greater_than_or_equal_to } # rubocop:disable Layout/LineLength
            )
          end
        end

        fillable_attributes.each do |attribute|
          it { is_expected.to allow_value(nil).for(attribute.name.to_sym) unless attribute.required? } # rubocop:disable Layout/LineLength
          it { is_expected.to allow_value(attribute.default).for(attribute.name.to_sym) }
        end

        migratable_attributes
          .grep_v(Attributes::Association)
          .grep_v(Attributes::Jsonb)
          .each do |attribute|
            it do
              is_expected
                .to have_db_column(attribute.column_name.to_sym)
                .of_type(attribute.database_type.to_sym)
            end
          end

        indexable_attributes
          .grep_v(Attributes::Association)
          .each do |attribute|
            it { is_expected.to have_db_index(attribute.name.to_sym) }
          end

        normalizable_attributes.each do |attribute|
          it { is_expected.to normalize(attribute.name.to_sym).from('').to(nil) }
        end

        attachments_attributes.each do |attribute|
          it { is_expected.to have_many_attached(attribute.name.to_sym).strict_loading }
          it do
            if attribute.options.min
              is_expected
                .to validate_limit_of(attribute.name.to_sym)
                .min(attribute.options.min)
            end
            if attribute.options.max
              is_expected
                .to validate_limit_of(attribute.name.to_sym)
                .max(attribute.options.max)
            end
          end
        end

        attachment_attributes
          .grep_v(Attributes::Attachments)
          .each do |attribute|
            it { is_expected.to have_one_attached(attribute.name.to_sym).strict_loading }
          end

        attachment_attributes.each do |attribute|
          it do
            is_expected
              .to accept_nested_attributes_for(attribute.association_name)
              .allow_destroy(true)
            is_expected.to validate_attached_of(attribute.name.to_sym) if attribute.required?
            if attribute.options.size
              is_expected
                .to validate_size_of(attribute.name.to_sym)
                .less_than(attribute.options.size.megabytes)
            end
            if attribute.options.width
              is_expected
                .to validate_dimensions_of(attribute.name.to_sym)
                .width(attribute.options.width)
            end
            if attribute.options.height
              is_expected
                .to validate_dimensions_of(attribute.name.to_sym)
                .height(attribute.options.height)
            end
            if attribute.options.content_type
              is_expected
                .to validate_content_type_of(attribute.name.to_sym)
                .allowing(*attribute.options.content_type)
            end
            if attribute.options.aspect_ratio
              is_expected
                .to validate_aspect_ratio_of(attribute.name.to_sym)
                .allowing(*attribute.options.aspect_ratio)
            end
          end
        end

        text_attributes.each do |attribute|
          it do
            is_expected.to(
              validate_length_of(attribute.name.to_sym)
                .tap { _1.is_at_least(attribute.min) if attribute.min }
                .tap { _1.is_at_most(attribute.limit) if attribute.limit }
                .tap { _1.is_equal_to(attribute.length) if attribute.length }
            )
          end
        end

        url_attributes.each do |attribute|
          it { is_expected.to validate_url_of(attribute.name.to_sym) }
        end

        decimal_attributes.each do |attribute|
          it do
            is_expected.to(
              validate_numericality_of(attribute.name.to_sym)
                .tap { _1.is_less_than(attribute.bound) if attribute.precision }
                .tap { _1.is_greater_than(-attribute.bound) if attribute.precision }
            )
          end
        end

        integer_attributes.each do |attribute|
          it { is_expected.to validate_numericality_of(attribute.name.to_sym).only_integer }
        end

        events.each do |event|
          it { is_expected.to respond_to(event.action) }
        end

        enum_attributes
          .grep_v(Attributes::Flag)
          .each do |attribute|
            it do
              is_expected
                .to define_enum_for(attribute.name.to_sym)
                .with_values(attribute.values)
                .with_default(attribute.options.default)
                .with_prefix
            end
          end

        rich_text_attributes
          .reject(&:translated?)
          .each do |attribute|
            it { is_expected.to have_rich_text(attribute.name.to_sym) }
          end

        digest_attributes.each do |attribute|
          it { is_expected.to have_secure_password(attribute.name.to_sym) }
          it do
            is_expected.to validate_confirmation_of(attribute.name.to_sym) if attribute.confirm?
            is_expected.to(
              validate_length_of(attribute.name.to_sym)
                .is_at_most(::ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED)
                .tap { _1.is_at_least(attribute.options.min) if attribute.options.min }
            )
          end
        end

        token_attributes.each do |attribute|
          it { is_expected.to have_secure_token(attribute.name.to_sym) }
          it { is_expected.to encrypt(attribute.name.to_sym).deterministic(true) }
        end

        one_time_password_attributes.each do |attribute|
          it { is_expected.to encrypt(attribute.name.to_sym).deterministic(true) }
        end

        association_attributes.each do |attribute|
          it { is_expected.to have_db_column(attribute.column_name.to_sym).of_type(:string) }
          it do
            is_expected.to(
              belong_to(attribute.name.to_sym)
                .with_foreign_key(attribute.column_name)
                .inverse_of(attribute.inverse_association.name.to_sym)
                .strict_loading
                .tap { _1.class_name(attribute.class_name) unless attribute.polymorphic? }
                .tap { _1.optional unless attribute.required? }
            )
          end
        end

        virtuals.each do |virtual|
          it { is_expected.to respond_to(virtual.name.to_sym) }
        end

        has_and_belongs_to_many_associations.each do |association|
          it do
            is_expected
              .to have_and_belong_to_many(association.name.to_sym)
              .class_name(association.class_name)
              .join_table(association.join_table)
              .strict_loading
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
              .strict_loading
          end
        end

        has_many_associations.each do |association|
          it do
            is_expected
              .to have_many(association.name.to_sym)
              .class_name(association.class_name)
              .with_foreign_key(association.column_name)
              .inverse_of(association.inverse_of.to_sym)
              .dependent(association.required? ? :destroy : :nullify)
              .strict_loading
          end
        end

        has_many_nested_associations.each do |association|
          it { is_expected.to accept_nested_attributes_for(association.name.to_sym) }
          it do
            is_expected
              .to have_many(association.name.to_sym)
              .class_name(association.class_name)
              .with_foreign_key(association.column_name)
              .inverse_of(association.inverse_of.to_sym)
              .dependent(association.required? ? :destroy : :nullify)
              .strict_loading
          end
        end

        has_one_associations.each do |association|
          it do
            is_expected
              .to have_one(association.name.to_sym)
              .class_name(association.class_name)
              .with_foreign_key(association.column_name)
              .inverse_of(association.inverse_of.to_sym)
              .strict_loading
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
              .strict_loading
          end
        end
      end

      class_methods do
        delegate :entity, to: :model_class
        delegate :attributes,
                 :virtuals,
                 :triggers,
                 :events,
                 :migratable_attributes,
                 :indexable_attributes,
                 :fillable_attributes,
                 :enumerable_attributes,
                 :numerable_attributes,
                 :normalizable_attributes,
                 :text_attributes,
                 :url_attributes,
                 :decimal_attributes,
                 :integer_attributes,
                 :enum_attributes,
                 :rich_text_attributes,
                 :digest_attributes,
                 :token_attributes,
                 :one_time_password_attributes,
                 :attachments_attributes,
                 :attachment_attributes,
                 :association_attributes,
                 :has_and_belongs_to_many_associations,
                 :has_many_through_associations,
                 :has_many_associations,
                 :has_many_nested_associations,
                 :has_one_associations,
                 :has_one_through_associations,
                 :default,
                 to: :entity

        def model_class
          top_level_description.constantize
        end
      end
    end
  end
end
