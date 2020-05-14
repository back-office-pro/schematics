module Schematics
  module Tests
    class Controller < ::ActionDispatch::IntegrationTest
      delegate :controller_class, to: :class
      delegate :model_class, to: :controller_class
      delegate :entity, to: :model_class
      delegate :email, to: :current_user
      delegate :sessions_path, to: 'Schematics::Engine.routes.url_helpers'

      class << self
        delegate :model_class, to: :controller_class
        delegate :entity, to: :model_class

        def inherited(subclass)
          super
          subclass.class_eval do
            setup do
              @record = send(entity.name.pluralize, :one)
              @params = entity.fillable_attributes.map do |attribute|
                [
                  attribute.column_name.to_sym,
                  attribute.default || @record.send(attribute.column_name),
                ]
              end.to_h
              @json_params = entity.fillable_attributes.map do |attribute|
                [
                  attribute.column_name.to_sym,
                  attribute.json_default || @record.send(attribute.column_name),
                ]
              end.to_h
            end

            test "should get edit" do
              login
              get edit_polymorphic_path(@record)
              assert_response :success
            end

            test "should show API #{entity.name}" do
              login as: :json
              get polymorphic_path(@record), headers: authorization_header, as: :json
              assert_response :success
            end

            test "should show PDF #{entity.name}" do
              login
              get polymorphic_path(@record), as: :pdf
              assert_response :success
            end

            test "should show #{entity.name}" do
              login
              get polymorphic_path(@record)
              assert_response :success
            end

            test "should update API #{entity.name}" do
              login as: :json
              patch polymorphic_path(@record),
                    params: { entity.name.to_sym => @json_params },
                    headers: authorization_header,
                    as: :json
              assert_response :success
            end

            test "should update #{entity.name}" do
              login
              patch polymorphic_path(@record),
                    params: { entity.name.to_sym => @params }
              assert_redirected_to polymorphic_path(@record.reload)
            end

            unless entity.is_a?(Entities::Singleton)
              test "should get API index" do
                login as: :json
                get polymorphic_path(model_class), headers: authorization_header, as: :json
                assert_response :success
              end

              test "should get CSV index" do
                login
                get polymorphic_path(model_class), as: :csv
                assert_response :success
              end

              test "should get index" do
                login
                get polymorphic_path(model_class)
                assert_response :success
              end

              test "should get new" do
                login
                get new_polymorphic_path(model_class)
                assert_response :success
              end

              test "should throw API #{entity.name} not found" do
                login as: :json
                get polymorphic_path(model_class).concat("/0"),
                    headers: authorization_header,
                    as: :json
                assert_response :not_found
              end

              test "should throw #{entity.name} not found" do
                login
                get polymorphic_path(model_class).concat("/0")
                assert_response :not_found
              end

              test "should really destroy API #{entity.name}" do
                assert_difference("#{model_class.name}.count", -1) do
                  login as: :json
                  delete polymorphic_path(@record),
                         headers: authorization_header,
                         params: { really: true },
                         as: :json
                end
                assert_response :success
              end

              test "should really destroy #{entity.name}" do
                assert_difference("#{model_class.name}.count", -1) do
                  login
                  delete polymorphic_path(@record), params: { really: true }
                end
                assert_redirected_to polymorphic_path(model_class)
              end

              test "should unarchive API #{entity.name}" do
                @record.destroy
                assert @record.deleted?
                assert_difference("#{model_class.name}.count") do
                  login as: :json
                  delete polymorphic_path(@record), headers: authorization_header, as: :json
                end
                assert_response :success
              end

              test "should unarchive #{entity.name}" do
                @record.destroy
                assert @record.deleted?
                assert_difference("#{model_class.name}.count") do
                  login
                  delete polymorphic_path(@record)
                end
                assert_redirected_to polymorphic_path(model_class)
              end

              test "should archive API #{entity.name}" do
                @record.restore
                refute @record.deleted?
                assert_difference("#{model_class.name}.count", -1) do
                  login as: :json
                  delete polymorphic_path(@record), headers: authorization_header, as: :json
                end
                assert_response :success
              end

              test "should archive #{entity.name}" do
                @record.restore
                refute @record.deleted?
                assert_difference("#{model_class.name}.count", -1) do
                  login
                  delete polymorphic_path(@record)
                end
                assert_redirected_to polymorphic_path(model_class)
              end

              test "should create API #{entity.name}" do
                assert_difference("#{model_class.name}.count") do
                  login as: :json
                  post polymorphic_path(model_class),
                       params: { entity.name.to_sym => @json_params },
                       headers: authorization_header,
                       as: :json
                end
                assert_response :created
              end

              test "should create #{entity.name}" do
                assert_difference("#{model_class.name}.count") do
                  login
                  post polymorphic_path(model_class), params: { entity.name.to_sym => @params }
                end
                assert_redirected_to polymorphic_path(model_class.last)
              end
            end
          end
        end

        def controller_class
          name.chomp('Test').constantize
        end
      end

      protected

      def current_user
        @current_user ||= users(:two)
      end

      def login(as: nil)
        post sessions_path,
             params: { user: { email: email, password: "secret" } },
             as: as
      end

      def authorization_header
        { Authorization: JSON.parse(@response.body)['auth_token'] }
      end
    end
  end
end
