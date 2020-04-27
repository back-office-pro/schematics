require 'action_text/system_test_helper'

module Schematics
  module Tests
    class System < ::ApplicationSystemTestCase
      driven_by :selenium_headless

      include ActionText::SystemTestHelper
      include Engine.routes.url_helpers

      delegate :model_class, to: :class
      delegate :entity, :model_name, to: :model_class
      delegate :email, to: :current_user

      class << self
        delegate :entity, :model_name, to: :model_class

        def inherited(subclass)
          super
          subclass.class_eval do
            setup do
              @record = send(entity.type.pluralize, :one)
              login
            end

            test "visiting the index" do
              visit polymorphic_path(model_class)
              title = I18n.t('schematics.schema.index.title',
                             model_name: model_name.human.pluralize.downcase)
              assert_selector "h5", text: title
            end

            test "creating a #{entity.type}" do
              visit polymorphic_path(model_class)
              click_on I18n.t('schematics.application.index.buttons.add',
                              model_name: model_name.human.downcase)
              fill_form(entity)
              click_on I18n.t('schematics.application.form.buttons.confirm')
              assert_text I18n.t('schematics.schema.create.created', model_name: model_name.human)
            end

            test "updating a #{entity.type}" do
              visit polymorphic_path(model_class)
              selector = "a[data-title='#{I18n.t('schematics.application.viewers.table.edit')}']"
              find(selector, match: :first).click
              fill_form(entity)
              click_on I18n.t('schematics.application.form.buttons.confirm')
              assert_text I18n.t('schematics.schema.update.updated', model_name: model_name.human)
            end

            test "archiving a #{entity.type}" do
              visit polymorphic_path(model_class)
              selector = "a[data-title='#{I18n.t('schematics.application.viewers.table.archive')}']"
              find(selector, match: :first).click
              assert_text I18n.t('schematics.schema.destroy.archived', model_name: model_name.human)
            end

            test "destroying a #{entity.type}" do
              visit polymorphic_path(model_class)
              find("tr[data-href] td:nth-child(2)", match: :first).click
              click_on I18n.t('schematics.application.show.buttons.destroy')
              click_on I18n.t('schematics.application.form.buttons.confirm')
              assert_text I18n.t('schematics.schema.destroy.destroyed',
                                 model_name: model_name.human)
            end
          end
        end

        def model_class
          name.chomp('Test').classify.constantize
        end
      end

      protected

      def current_user
        @current_user ||= users(:two)
      end

      def login
        visit login_path
        fill_in I18n.t('simple_form.labels.user.email'), with: email
        fill_in I18n.t('simple_form.labels.user.password'), with: "secret"
        click_on I18n.t('schematics.application.form.buttons.confirm')
        assert_text I18n.t('schematics.sessions.create.logged_in')
      end

      def fill_form(entity)
        entity.fillable_attributes.each do |attribute|
          input = "#{entity.type}[#{attribute.column_name}]"
          case attribute
          when Attributes::Enum
            choose(input, match: :first, allow_label_click: true)
          when Attributes::Boolean
            check(input) if @record.send(attribute.name)
          when Attributes::Attachments
            attach_file(input + "[]", attribute.default.first.path, make_visible: true)
          when Attributes::Attachment
            attach_file(input, attribute.default.path, make_visible: true)
          when Attributes::RichText
            fill_in_rich_text_area input, with: attribute.default
          when Attributes::BelongsTo
            select @record.instance_eval(attribute.name), from: input, match: :first
          when Attributes::Digest
            digest = attribute.default
            fill_in input, with: digest
            fill_in "#{entity.type}[#{attribute.column_name}_confirmation]", with: digest
          else
            fill_in input, with: attribute.default || @record.send(attribute.name)
          end
        end
      end
    end
  end
end
