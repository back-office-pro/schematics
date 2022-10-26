# frozen_string_literal: true

require 'active_support/concern'

module Schematics
  module Specs
    module Feature # rubocop:disable Metrics/ModuleLength
      extend ActiveSupport::Concern

      CREATE_DENYLIST = [::Search, ::Session, ::Comparison, ::SchemaDataset, ::Comment].freeze

      included do
        include Rails.application.routes.url_helpers
        delegate :t, to: 'I18n'
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
          ::Role.create!(name: 'Admin', permissions: ::Permission.create_all_entities_permissions!)
        end
        let(:user) do
          ::User.create!(
            email: 'admin@admin.com',
            password: 'Azerty1!',
            first_name: 'John',
            last_name: 'Doe',
            time_zone: 'Paris',
            locale: Rails.configuration.i18n.default_locale,
            role:
          )
        end
        let(:login) do
          visit login_path
          fill_in ::User.human_attribute_name('email'), with: user.email
          fill_in ::User.human_attribute_name('password'), with: 'Azerty1!'
          click_on t('schematics.application.button.confirm')
          is_expected.to have_text t('sessions.create.success')
        end

        before do
          allow(ActiveRecord::Base).to receive(:lock_optimistically).and_return(false)
          record
          role
          model_class.reindex
          login
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

        if can?(:create) && CREATE_DENYLIST.exclude?(model_class)
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
        delegate :can?, :default, to: :entity

        def model_class
          description.constantize
        end
      end

      private

      def fill_form # rubocop:disable Metrics/CyclomaticComplexity
        entity.fillable_elements.each do |element|
          input = "#{entity.name}[#{element.column_name}]"
          case element
          when Associations::HasAndBelongsToMany
            # Do nothing
          when Attributes::Boolean
            check(input)
          when Attributes::Attachments
            attach_file "#{input}[]", element.default.first.path
          when Attributes::Attachment
            attach_file input, element.default.path
          when Attributes::RichText
            find_field(input, type: :hidden).set(element.default)
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
            fill_in input, with: element.default
            fill_in "#{entity.name}[#{element.column_name}_confirmation]", with: element.default
          when Attributes::Date
            fill_in input, with: element.default.to_date
          when Attributes::Array
            fill_in "#{input}[]", with: element.default
          else
            fill_in input, with: element.default
          end
        end
      end
    end
  end
end
