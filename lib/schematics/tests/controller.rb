# frozen_string_literal: true

module Schematics
  module Tests
    class Controller < ::ActionDispatch::IntegrationTest
      delegate :controller_class, to: :class, private: true
      delegate :model_class, to: :controller_class, private: true
      delegate :entity, to: :model_class, private: true
      delegate :email, to: :current_user, private: true
      delegate :sessions_path, to: 'Schematics::Engine.routes.url_helpers', private: true

      class << self
        delegate :model_class, to: :controller_class, private: true
        delegate :entity, to: :model_class, private: true

        def inherited(subclass)
          super
          subclass.class_eval do
            PaperTrail.enabled = false
            model_class.reindex

            setup do
              Engine.load_seed
              current_user.update!(role: Role.find_by(name: 'Admin'))
              Licence.instance.update!(plan: 'enterprise', expires_at: 12.months.from_now)
            end

            test_index_api
            test_index_csv
            test_index
            test_show_api
            test_show_pdf
            test_show
            test_not_found
            test_not_found_api
            test_edit
            test_update_api
            test_update
            test_new
            test_create_api
            test_create
            test_delete
            test_destroy_api
            test_destroy
            test_restore_api
            test_restore
            test_archive_api
            test_archive
          end
        end

        def controller_class
          name.chomp('Test').constantize
        end

        def test_index_api
          return unless entity.can?(:index)

          test 'should get API index' do
            login formats: :json
            get polymorphic_path(model_class), headers: authorization_header, as: :json
            assert_response :success
          end
        end

        def test_index_csv
          return unless entity.can?(:index)

          test 'should get CSV index' do
            login
            get polymorphic_path(model_class), as: :csv
            assert_response :success
          end
        end

        def test_index
          return unless entity.can?(:index)

          test 'should get index' do
            login
            get polymorphic_path(model_class)
            assert_response :success
          end
        end

        def test_show_api
          return unless entity.can?(:show)

          test "should show API #{entity.table_name}" do
            login formats: :json
            get polymorphic_path(record), headers: authorization_header, as: :json
            assert_response :success
          end
        end

        def test_show_pdf
          return unless entity.can?(:show)

          test "should show PDF #{entity.table_name}" do
            login
            get polymorphic_path(record), as: :pdf
            assert_response :success
          end
        end

        def test_show
          return unless entity.can?(:show)

          test "should show #{entity.table_name}" do
            login
            get polymorphic_path(record)
            assert_response :success
          end
        end

        def test_not_found
          return unless entity.can?(:index)

          test "should throw #{entity.table_name} not found" do
            login
            get polymorphic_path(model_class).concat('/0')
            assert_redirected_to polymorphic_path(model_class)
          end
        end

        def test_not_found_api
          return unless entity.can?(:index)

          test "should throw API #{entity.table_name} not found" do
            login formats: :json
            get polymorphic_path(model_class).concat('/0'),
                headers: authorization_header,
                as: :json
            assert_response :not_found
          end
        end

        def test_edit
          return unless entity.can?(:edit)

          test 'should get edit' do
            login
            get edit_polymorphic_path(record)
            assert_response :success
          end
        end

        def test_update_api
          return unless entity.can?(:update)

          test "should update API #{entity.table_name}" do
            login formats: :json
            patch polymorphic_path(record),
                  params: params(formats: :json),
                  headers: authorization_header,
                  as: :json
            assert_response :success
          end
        end

        def test_update
          return unless entity.can?(:update)

          test "should update #{entity.table_name}" do
            login
            patch(polymorphic_path(record), params:)
            assert_redirected_to polymorphic_path(record.reload)
          end
        end

        def test_new
          return unless entity.can?(:new)

          test 'should get new' do
            login
            get new_polymorphic_path(model_class)
            assert_response :success
          end
        end

        def test_create_api
          return unless entity.can?(:create)

          test "should create API #{entity.table_name}" do
            assert_difference("#{model_class.name}.count") do
              login formats: :json
              post polymorphic_path(model_class),
                   params: params(formats: :json),
                   headers: authorization_header,
                   as: :json
            end
            assert_response :created
          end
        end

        def test_create
          return unless entity.can?(:create)

          test "should create #{entity.table_name}" do
            assert_difference("#{model_class.name}.count") do
              login
              post(polymorphic_path(model_class), params:)
            end
            assert_redirected_to polymorphic_path(model_class.last)
          end
        end

        def test_delete
          return unless entity.can?(:delete)

          test 'should get delete' do
            login
            get polymorphic_path(record, action: :delete)
            assert_response :success
          end
        end

        def test_destroy_api
          return unless entity.can?(:destroy)

          test "should destroy API #{entity.table_name}" do
            assert_difference("#{model_class.name}.count", -1) do
              login formats: :json
              delete polymorphic_path(record),
                     headers: authorization_header,
                     as: :json
            end
            assert_response :success
          end
        end

        def test_destroy
          return unless entity.can?(:destroy)

          test "should destroy #{entity.table_name}" do
            assert_difference("#{model_class.name}.count", -1) do
              login
              delete polymorphic_path(record)
            end
            assert_redirected_to polymorphic_path(model_class)
          end
        end

        def test_restore_api
          return unless entity.can?(:restore)

          test "should restore API #{entity.table_name}" do
            record.destroy!
            assert record.deleted?
            assert_difference("#{model_class.name}.count") do
              login formats: :json
              delete polymorphic_path(record, action: :restore),
                     headers: authorization_header,
                     as: :json
            end
            assert_response :success
          end
        end

        def test_restore
          return unless entity.can?(:restore)

          test "should restore #{entity.table_name}" do
            record.destroy!
            assert record.deleted?
            assert_difference("#{model_class.name}.count") do
              login
              delete polymorphic_path(record, action: :restore)
            end
            assert_redirected_to polymorphic_path(model_class)
          end
        end

        def test_archive_api
          return unless entity.can?(:archive)

          test "should archive API #{entity.table_name}" do
            record.restore
            refute record.deleted?
            assert_difference("#{model_class.name}.count", -1) do
              login formats: :json
              delete polymorphic_path(record, action: :archive),
                     headers: authorization_header,
                     as: :json
            end
            assert_response :success
          end
        end

        def test_archive
          return unless entity.can?(:archive)

          test "should archive #{entity.table_name}" do
            record.restore
            refute record.deleted?
            assert_difference("#{model_class.name}.count", -1) do
              login
              delete polymorphic_path(record, action: :archive)
            end
            assert_redirected_to polymorphic_path(model_class)
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

      def login(formats: nil)
        post sessions_path,
             params: { user: { email:, password: 'secret' } },
             as: formats
      end

      def authorization_header
        { Authorization: JSON.parse(@response.body)['auth_token'] }
      end

      def params(formats: nil)
        default_attribute = [formats, 'default'].compact.join('_')
        {
          entity.table_name.to_sym => entity.fillable_elements.to_h do |element|
            [
              element.column_name.to_sym,
              element.public_send(default_attribute) || record.public_send(element.column_name)
            ]
          end
        }
      end
    end
  end
end
