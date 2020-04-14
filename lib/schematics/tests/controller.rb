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
            scopes = controller_class.scopes_configuration

            setup do
              @record = send(entity.type.pluralize, :one)
              @params = entity.attributes.select(&:permitted_param).map do |attribute|
                [
                  attribute.column_name.to_sym,
                  attribute.default || @record.send(attribute.column_name),
                ]
              end.to_h
              @json_params = entity.attributes.select(&:permitted_json_param).map do |attribute|
                [
                  attribute.column_name.to_sym,
                  attribute.json_default || @record.send(attribute.column_name),
                ]
              end.to_h
            end

            test "should have scope with_deleted" do
              assert scopes.include?(:with_deleted)
              assert scopes[:with_deleted][:only] == [:index]
              assert scopes[:with_deleted][:type] == :boolean
            end

            entity.filterable_elements.each do |element|
              scope = :"by_#{element.name}"
              test "should have filter scope #{scope}" do
                assert scopes.include?(scope)
                assert scopes[scope][:only] == [:index]
                assert scopes[scope][:type] == :boolean if element.is_a?(Attributes::Boolean)
                if element.is_a?(Behaviours::Range::Filterable) ||
                   element.is_a?(Virtuals::Calculation)
                  assert scopes[scope][:using] == [:from, :to]
                end
              end
            end

            entity.sortable_elements.each do |element|
              scope = :"sort_by_#{element.name}"
              test "should have sort scope #{scope}" do
                assert scopes.include?(scope)
              end
            end

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

            test "should get edit" do
              login
              get edit_polymorphic_path(@record)
              assert_response :success
            end

            test "should show API #{entity.type}" do
              login as: :json
              get polymorphic_path(@record), headers: authorization_header, as: :json
              assert_response :success
            end

            test "should show PDF #{entity.type}" do
              login
              get polymorphic_path(@record), as: :pdf
              assert_response :success
            end

            test "should show #{entity.type}" do
              login
              get polymorphic_path(@record)
              assert_response :success
            end

            test "should throw API #{entity.type} not found" do
              login as: :json
              get polymorphic_path(model_class).concat("/0"),
                  headers: authorization_header,
                  as: :json
              assert_response :not_found
            end

            test "should throw #{entity.type} not found" do
              login
              get polymorphic_path(model_class).concat("/0")
              assert_response :not_found
            end

            test "should really destroy API #{entity.type}" do
              assert_difference("#{model_class.name}.count", -1) do
                login as: :json
                delete polymorphic_path(@record),
                       headers: authorization_header,
                       params: { really: true },
                       as: :json
              end
              assert_response :no_content
            end

            test "should really destroy #{entity.type}" do
              assert_difference("#{model_class.name}.count", -1) do
                login
                delete polymorphic_path(@record), params: { really: true }
              end
              assert_redirected_to polymorphic_path(model_class)
            end

            test "should unarchive API #{entity.type}" do
              @record.destroy
              assert @record.deleted?
              assert_difference("#{model_class.name}.count") do
                login as: :json
                delete polymorphic_path(@record), headers: authorization_header, as: :json
              end
              assert_response :no_content
            end

            test "should unarchive #{entity.type}" do
              @record.destroy
              assert @record.deleted?
              assert_difference("#{model_class.name}.count") do
                login
                delete polymorphic_path(@record)
              end
              assert_redirected_to polymorphic_path(model_class)
            end

            test "should archive API #{entity.type}" do
              @record.restore
              refute @record.deleted?
              assert_difference("#{model_class.name}.count", -1) do
                login as: :json
                delete polymorphic_path(@record), headers: authorization_header, as: :json
              end
              assert_response :no_content
            end

            test "should archive #{entity.type}" do
              @record.restore
              refute @record.deleted?
              assert_difference("#{model_class.name}.count", -1) do
                login
                delete polymorphic_path(@record)
              end
              assert_redirected_to polymorphic_path(model_class)
            end

            test "should update API #{entity.type}" do
              login as: :json
              patch polymorphic_path(@record),
                    params: { entity.type.to_sym => @json_params },
                    headers: authorization_header,
                    as: :json
              assert_response :no_content
            end

            test "should update #{entity.type}" do
              login
              patch polymorphic_path(@record),
                    params: { entity.type.to_sym => @params }
              assert_redirected_to polymorphic_path(@record.reload)
            end

            test "should create API #{entity.type}" do
              assert_difference("#{model_class.name}.count") do
                login as: :json
                post polymorphic_path(model_class),
                     params: { entity.type.to_sym => @json_params },
                     headers: authorization_header,
                     as: :json
              end
              assert_response :created
            end

            test "should create #{entity.type}" do
              assert_difference("#{model_class.name}.count") do
                login
                post polymorphic_path(model_class), params: { entity.type.to_sym => @params }
              end
              assert_redirected_to polymorphic_path(model_class.last)
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
        { Authorization: JSON.parse(@response.body)['authToken'] }
      end
    end
  end
end
