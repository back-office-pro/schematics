# frozen_string_literal: true

require 'active_support/concern'

module Schematics
  module Specs
    module Feature # rubocop:disable Metrics/ModuleLength
      extend ActiveSupport::Concern

      included do
        fixtures :all
        delegate :t, to: 'I18n'
        delegate :login_path, to: 'Rails.application.routes.url_helpers'
        delegate :entity,
                 :entity_fixtures,
                 :model_class,
                 :human_name,
                 :human_name_plural,
                 :path,
                 :can?,
                 to: :class

        subject { page }

        let(:record) { __send__(entity_fixtures, :one) }
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
          allow_any_instance_of(::Licence).to receive(:expires_on).and_return(1.day.from_now)
          record
          role
          model_class.reindex
          login
        end

        if can?(:index)
          scenario 'visiting the index' do
            if ability.can?(:index, model_class)
              visit path
              text = t('titles.schematics.resources.index', human_name_plural:)
              is_expected.to have_selector 'h6', text:
            end
          end
        end

        if can?(:create) && [::Search, ::SchemaDataset].exclude?(model_class)
          scenario "creating a #{entity.name}" do
            if ability.can?(:new, model_class)
              visit path(action: 'new')
              fill_form(record)
              click_on t('schematics.application.button.confirm')
              is_expected.to have_text t('schematics.resources.create.success', human_name:)
            end
          end
        end

        if can?(:update)
          scenario "updating a #{entity.name}" do
            if ability.can?(:edit, record)
              visit path(record:, action: 'edit')
              fill_form(record)
              click_on t('schematics.application.button.confirm')
              is_expected.to have_text t('schematics.resources.update.success', human_name:)
            end
          end
        end
      end

      class_methods do
        delegate :entity, :human_name, :human_name_plural, :model_name, to: :model_class
        delegate :can?, to: :entity
        delegate :route_key, to: :model_name

        def model_class
          description.constantize
        end

        def entity_fixtures = entity
          .table_name
          .pluralize
          .to_sym

        def path(record: nil, action: nil)
          ["/#{route_key}", (record&.id unless entity.is_a?(Entities::Singleton)), action]
            .compact
            .join('/')
        end
      end

      private

      # :reek:FeatureEnvy
      def fill_form(record) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/AbcSize
        entity.fillable_elements.each do |element|
          input = "#{entity.name}[#{element.column_name}]"
          case element
          when Associations::HasAndBelongsToMany
            select record.public_send(element.name).first.to_s,
                   from: "#{input}[]",
                   match: :first
          when Attributes::Boolean
            check(input) if record.public_send(element.name)
          when Attributes::Attachments
            attach_file "#{input}[]", element.default.first.path
          when Attributes::Attachment
            attach_file input, element.default.path
          when Attributes::RichText
            find_field(input, type: :hidden).set(element.default)
          when Attributes::BelongsTo
            select record.public_send(element.name).to_s,
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
            fill_in input, with: element.default || record.public_send(element.name)
          end
        end
      end
    end
  end
end
