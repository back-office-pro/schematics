# frozen_string_literal: true

require 'active_support/concern'

module Schematics
  module Specs
    module Feature # rubocop:disable Metrics/ModuleLength
      extend ActiveSupport::Concern

      included do
        include Rails.application.routes.url_helpers
        delegate :available_locales, to: 'Schematics::Engine.config.i18n'
        delegate :t, to: ::I18n
        delegate :entity,
                 :model_class,
                 :human_name,
                 :human_name_plural,
                 :can?,
                 :default,
                 to: :class

        subject { page }

        let(:record) { default.tap(&:save!) }
        let(:ability) { Ability.new(user) }
        let(:role) do
          Core::Role.create!(name: 'Admin', permissions: Core::Permission.create_entities_permissions!)
        end
        let(:user) do
          Core::User.create!(
            email: 'admin@admin.com',
            password: 'Azerty1!',
            first_name: 'John',
            last_name: 'Doe',
            role:
          )
        end
        let(:login) do
          visit login_path
          fill_in Core::User.human_attribute_name('email'), with: user.email
          fill_in Core::User.human_attribute_name('password'), with: 'Azerty1!'
          click_on t('schematics.application.button.confirm')
          is_expected.to have_text t('sessions.create.success')
        end

        before do
          allow(ActiveRecord::Base).to receive(:lock_optimistically).and_return(false)
          [record, role, login]
        end

        if can?(:index)
          scenario 'visiting the index' do
            if ability.can?(:index, model_class)
              visit polymorphic_path(model_class)
              text = t('titles.schematics.resources.index', human_name_plural:)
              is_expected.to have_selector 'h6', text:
            end
          end
        end

        if can?(:create)
          scenario "creating a #{entity.name}" do
            if ability.can?(:new, model_class)
              visit new_polymorphic_path(model_class)
              fill_form
              click_on t('schematics.application.button.confirm')
              is_expected.to have_text t('schematics.resources.create.success', human_name:)
            end
          end
        end

        if can?(:update)
          scenario "updating a #{entity.name}" do
            if ability.can?(:edit, record)
              visit edit_polymorphic_path(record)
              fill_form
              click_on t('schematics.application.button.confirm')
              is_expected.to have_text t('schematics.resources.update.success', human_name:)
            end
          end
        end
      end

      class_methods do
        delegate :entity, :human_name, :human_name_plural, to: :model_class
        delegate :default, to: :entity

        def model_class
          description.constantize
        end

        def allow?(action)
          Array(metadata[:except]).exclude?(action)
        end

        def can?(action)
          entity.can?(action) && allow?(action)
        end
      end

      private

      # :reek:FeatureEnvy
      def fill_form # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/AbcSize
        entity.fillable_elements.each do |element|
          input = "#{entity.name}[#{element.column_name}]"
          case element
          when Associations::HasAndBelongsToMany
            select element.inverse_entity.model_class.first.to_s,
                   from: "#{input}[]",
                   match: :first
          when Attributes::Boolean
            check(input)
          when Attributes::Attachments
            attach_file "#{input}[]", element.default.first.path
          when Attributes::Attachment
            attach_file input, element.default.path
          when Attributes::RichText
            type = element.required? ? :text : :hidden
            if element.translated?
              available_locales.each do |locale|
                find_field("#{entity.name}[#{element.column_name}_#{locale}]", type:)
                  .set(element.default)
              end
            else
              find_field(input, type:).set(element.default)
            end
          when Attributes::BelongsTo
            select element.inverse_entity.model_class.first.to_s,
                   from: input,
                   match: :first
          when Behaviours::Enumerable
            select element.format(element.default),
                   from: input,
                   match: :first
          when Attributes::Address
            find_field(input, type: :select).set(element.default)
          when Attributes::Digest
            element
              .permitted_params
              .each { |param| fill_in "#{entity.name}[#{param}]", with: element.default }
          when Attributes::Date
            fill_in input, with: element.default.to_date
          when Attributes::Array
            find_field("#{input}[]", type: :select).set(element.default)
          when Behaviours::Translatable
            if element.translated?
              available_locales.each do |locale|
                fill_in "#{entity.name}[#{element.column_name}_#{locale}]", with: element.default
              end
            else
              fill_in input, with: element.default
            end
          else
            fill_in input, with: element.default
          end
        end
      end
    end
  end
end
