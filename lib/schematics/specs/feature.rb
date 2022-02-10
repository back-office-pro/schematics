# frozen_string_literal: true

require 'active_support/concern'

module Schematics
  module Specs
    module Feature
      extend ActiveSupport::Concern

      included do
        delegate :entity,
                 :model_class,
                 :human_name,
                 :human_name_plural,
                 :login_path,
                 :fill_form,
                 :t,
                 to: :class,
                 private: true

        fixtures :users

        let(:user) { users(:one) }

        before do
          visit login_path
          fill_in t('simple_form.labels.user.email'), with: user.email
          fill_in t('simple_form.labels.user.password'), with: 'Azerty1!'
          click_on t('schematics.application.button.confirm')
          assert_text t('schematics.sessions.create.success')
          visit polymorphic_path(model_class)
        end

        unless entity.is_a?(Entities::Singleton)
          scenario 'visiting the index' do
            assert_selector 'h5', text: t('titles.schematics.resources.index', human_name_plural:)
          end

          scenario "creating a #{entity.name}" do
            click_on t('schematics.application.button.add', human_name:)
            fill_form
            click_on t('schematics.application.button.confirm')
            assert_text t('schematics.resources.create.success', human_name:)
          end

          scenario "archiving a #{entity.name}" do
            title = t('schematics.application.button.tooltip.archive')
            find("a[data-title='#{title}']", match: :first).click
            assert_text t('schematics.resources.archive.success', human_name:)
          end

          scenario "destroying a #{entity.name}" do
            find('*[data-href]', match: :first).click
            click_on t('schematics.application.button.destroy')
            click_on t('schematics.application.button.confirm')
            assert_text t('schematics.resources.destroy.success', human_name:)
          end
        end
      end

      class_methods do
        delegate :entity, :human_name, :human_name_plural, to: :model_class
        delegate :login_path, to: 'Schematics::Engine.routes.url_helpers'
        delegate :t, to: 'I18n'

        def model_class
          name.demodulize.split('_').first.constantize
        end

        def fill_form # rubocop:disable Metrics/CyclomaticComplexity
          entity.fillable_elements.each do |element| # rubocop:disable Metrics/BlockLength
            input = "#{entity.name}[#{element.column_name}]"
            case element
            when Associations::HasAndBelongsToMany
              check "#{input}[]",
                    match: :first,
                    allow_label_click: true
            when Attributes::Boolean
              check(input) if record.send(element.name)
            when Attributes::Attachments
              attach_file "#{input}[]",
                          element.default.first.path,
                          make_visible: true
            when Attributes::Attachment
              attach_file input,
                          element.default.path,
                          make_visible: true
            when Attributes::RichText
              fill_in_rich_text_area input, with: element.default
            when Attributes::BelongsTo
              select record.public_send(element.name).to_s,
                     from: input,
                     match: :first
            when Behaviours::Enumerable
              select element.format(element.default),
                     from: input,
                     match: :first
            when Attributes::Digest
              fill_in input, with: element.default
              fill_in "#{entity.name}[#{element.column_name}_confirmation]", with: element.default
            when Attributes::Date
              fill_in input, with: element.default.to_date
            else
              fill_in input, with: element.default || record.send(element.name)
            end
          end
        end
      end
    end
  end
end
