# frozen_string_literal: true

require 'active_support/concern'

module Schematics
  module Specs
    module Feature # rubocop:disable Metrics/ModuleLength
      extend ActiveSupport::Concern

      included do
        include ResourcesHelper

        delegate :t, to: '::I18n'
        delegate :available_locales, to: '::Configuration'
        delegate :entity,
                 :model_class,
                 :human_name,
                 :human_name_plural,
                 :can?,
                 :default,
                 :default_associations,
                 to: :class

        subject { page }

        let(:record) { default.tap(&:save!) }
        let(:ability) { Ability.new(user) }
        let(:role) do
          ::Role.create!(name: 'Admin', permissions: ::Permission.create_entities_permissions!)
        end
        let(:user) do
          ::User.create!(
            email: 'john.doe@nowhere.com',
            password: Attributes::Digest::DEFAULT,
            first_name: 'John',
            last_name: 'Doe',
            otp_last_at: 1.year.ago.to_i,
            teams: ::Team.all,
            role:
          )
        end
        let(:fill_in_otp) do
          user.otp_code_chars.each_with_index do |digit, index|
            all(:fillable_field, 'user[otp_attempt_digits][]')[index].set(digit)
          end
        end
        let(:login_with_2fa) do
          visit login_path
          fill_in 'session[email]', with: user.email
          fill_in 'session[password]', with: user.password
          click_button 'Confirm'
          is_expected.to have_text t('sessions.create.challenge')
          fill_in_otp
          click_button 'Confirm'
          is_expected.to have_text t('schematics.one_time_passwords.create.success')
        end

        before do
          allow(ActiveRecord::Base).to receive(:lock_optimistically).and_return(false)
          allow_any_instance_of(ActiveStorageValidations::ContentTypeValidator)
            .to receive(:enable_spoofing_protection?)
            .and_return(false)
        end

        if can?(:index)
          it 'visits the index' do
            if ability.can?(:index, model_class)
              login_with_2fa
              visit resources_path(model_class)
              text = t('titles.schematics.resources.index', human_name_plural:)
              is_expected.to have_selector 'h6', text:
            end
          end
        end

        if can?(:create)
          it "creates a #{entity.name}" do
            default_associations.each(&:save!)
            if ability.can?(:new, model_class)
              login_with_2fa
              visit new_resource_path(model_class)
              fill_form form_elements
              click_button 'Confirm'
              is_expected.to have_text t('schematics.resources.create.success', human_name:)
            end
          end
        end

        if can?(:update)
          it "updates a #{entity.name}" do
            record
            if ability.can?(:edit, record)
              login_with_2fa
              visit edit_resource_path(record)
              fill_form form_elements_for_update
              click_button 'Confirm'
              is_expected.to have_text t('schematics.resources.update.success', human_name:)
            end
          end
        end
      end

      class_methods do
        delegate :entity, :human_name, :human_name_plural, to: :model_class
        delegate :default, :default_associations, to: :entity

        def model_class
          top_level_description.constantize
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
      def fill_form(elements) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/AbcSize
        elements.each do |element|
          input_name = element.input_name(entity)
          case element
          when Associations::HasAndBelongsToMany
            select element.model_class.find(&element.filter_by).to_s,
                   from: input_name,
                   match: :first
          when Attributes::BelongsTo
            select element.model_class.first.to_s,
                   from: input_name,
                   match: :first
          when Attributes::Boolean
            check(input_name)
          when Attributes::Attachments
            attach_file input_name, element.default.first.path
          when Attributes::Attachment
            attach_file input_name, element.default.path
          when Attributes::RichText
            type = element.required? ? :text : :hidden
            if element.translated?
              available_locales.each do |locale|
                find_field("#{entity.table_name}[#{element.column_name}_#{locale}]", type:)
                  .set(element.default)
              end
            else
              find_field(input_name, type:).set(element.default)
            end
          when Behaviours::Enumerable
            select element.format(element.default),
                   from: input_name,
                   match: :first
          when Attributes::Address, Attributes::Array
            select element.name,
                   from: input_name,
                   match: :prefer_exact
          when Attributes::Digest
            element
              .permitted_params
              .each { |param| fill_in "#{entity.table_name}[#{param}]", with: element.default }
          when Attributes::Date
            fill_in input_name, with: element.default.to_date
          when Behaviours::Translatable
            if element.translated?
              available_locales.each do |locale|
                fill_in "#{entity.table_name}[#{element.column_name}_#{locale}]",
                        with: element.default
              end
            else
              fill_in input_name, with: element.default
            end
          else
            fill_in input_name, with: element.default
          end
        end
      end

      def form_elements = entity
        .fillable_elements
        .grep_v(Associations::HasMany)
        .grep_v(Attributes::User)

      def form_elements_for_update
        form_elements.select { ability.can?(:update, record, it.name.to_sym) }
      end
    end
  end
end
