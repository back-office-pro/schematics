# frozen_string_literal: true

module Schematics
  module Tests
    class System < ::ActionDispatch::SystemTestCase
      driven_by :selenium_headless
      delegate :model_class, to: :class, private: true
      delegate :entity, :model_name, to: :model_class, private: true
      delegate :email, to: :current_user, private: true
      delegate :login_path, to: 'Schematics::Engine.routes.url_helpers', private: true

      class << self
        delegate :entity, :model_name, to: :model_class, private: true

        def inherited(subclass)
          super
          subclass.class_eval do
            PaperTrail.enabled = false
            Searchkick.disable_callbacks
            model_class.reindex

            setup do
              Searchkick.enable_callbacks
              Engine.load_seed
              current_user.update!(role: ::Role.admin)
              ::Licence.instance.update!(plan: 'enterprise', expires_at: 12.months.from_now)
              login
            end

            teardown do
              model_class.search_index.refresh
              Searchkick.disable_callbacks
            end

            test_index
            test_create
            test_update
            test_archive
            test_destroy
          end
        end

        def model_class
          name.chomp('Test').classify.constantize
        end

        def test_index
          return unless entity.can?(:index)

          test 'visiting the index' do
            visit polymorphic_path(model_class)
            text = I18n.t(
              'titles.schematics.resources.index',
              model_name_plural: model_name.human.pluralize.downcase
            )
            assert_selector('h5', text:)
          end
        end

        def test_create
          return unless entity.can?(:create)

          test "creating a #{entity.table_name}" do
            visit polymorphic_path(model_class)
            click_on I18n.t(
              'schematics.application.button.add',
              model_name: model_name.human.downcase
            )
            fill_form
            click_on I18n.t('schematics.application.button.confirm')
            assert_text I18n.t(
              'schematics.resources.create.success',
              model_name: model_name.human
            )
          end
        end

        def test_update
          return unless entity.can?(:update)

          test "updating a #{entity.table_name}" do
            visit polymorphic_path(model_class)
            case entity
            when Entities::Singleton
              click_on I18n.t('schematics.application.button.edit')
            else
              selector = "a[data-title='#{I18n.t('schematics.application.button.tooltip.edit')}']"
              find(selector, match: :first).click
            end
            fill_form
            click_on I18n.t('schematics.application.button.confirm')
            assert_text I18n.t(
              'schematics.resources.update.success',
              model_name: model_name.human
            )
          end
        end

        def test_archive
          return unless entity.can?(:archive)

          test "archiving a #{entity.table_name}" do
            visit polymorphic_path(model_class)
            title = I18n.t('schematics.application.button.tooltip.archive')
            selector = "a[data-title='#{title}']"
            find(selector, match: :first).click
            assert_text I18n.t(
              'schematics.resources.archive.success',
              model_name: model_name.human
            )
          end
        end

        def test_destroy
          return unless entity.can?(:destroy)

          test "destroying a #{entity.table_name}" do
            visit polymorphic_path(model_class)
            page.execute_script("$('*[data-href]').first().click()")
            click_on I18n.t('schematics.application.button.destroy')
            click_on I18n.t('schematics.application.button.confirm')
            assert_text I18n.t(
              'schematics.resources.destroy.success',
              model_name: model_name.human
            )
          end
        end
      end

      protected

      def current_user
        @current_user ||= users(:two)
      end

      def record
        @record ||= __send__(entity.table_name.pluralize, :one)
      end

      def login
        visit login_path
        fill_in I18n.t('simple_form.labels.user.email'), with: email
        fill_in I18n.t('simple_form.labels.user.password'), with: 'secret'
        click_on I18n.t('schematics.application.button.confirm')
        assert_text I18n.t('schematics.sessions.create.success')
      end

      def fill_form # rubocop:disable Metrics/CyclomaticComplexity
        entity.fillable_elements.each do |element| # rubocop:disable Metrics/BlockLength
          input = "#{entity.table_name}[#{element.column_name}]"
          case element
          when Associations::HasAndBelongsToMany
            check "#{input}[]",
                  match: :first,
                  allow_label_click: true
          when Attributes::Boolean
            check(input) if record.public_send(element.name)
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
            fill_in "#{entity.table_name}[#{element.column_name}_confirmation]",
                    with: element.default
          when Attributes::Date
            fill_in input, with: element.default.to_date
          else
            fill_in input, with: element.default || record.public_send(element.name)
          end
        end
      end
    end
  end
end
