module Schematics
  module Tests
    class Controller < ::ActionDispatch::IntegrationTest
      class << self
        def inherited(subclass)
          super
          subclass.class_eval do
            entity = SCHEMA.find_entity_by_type(subclass.entity_name)
            scopes = subclass.controller_name.constantize.scopes_configuration

            setup do
              @record = send(subclass.fixture_name, :one)
              @params = entity.attributes.select(&:permitted_param).map do |attribute|
                [attribute.column_name.to_sym, attribute.default || @record.send(attribute.column_name)]
              end.to_h
              @json_params = entity.attributes.select(&:permitted_json_param).map do |attribute|
                [attribute.column_name.to_sym, attribute.json_default || @record.send(attribute.column_name)]
              end.to_h
            end

            test "should have scope with_deleted" do
              assert scopes.include?(:with_deleted)
              assert scopes[:with_deleted][:only] === [:index]
              assert scopes[:with_deleted][:type] === :boolean
            end

            entity.attributes.select(&:has_filter_scope).each do |attribute|
              scope = "by_#{attribute.name}".to_sym
              test "should have scope #{scope}" do
                assert scopes.include?(scope)
                assert scopes[scope][:only] === [:index]
                assert scopes[scope][:using] === [:from, :to] if attribute.is_a?(Attributes::Date)
                assert scopes[scope][:type] === :boolean if attribute.is_a?(Attributes::Boolean)
              end
            end

            entity.virtuals.each do |virtual|
              scope = "by_#{virtual.name}".to_sym
              test "should have scope #{scope}" do
                assert scopes.include?(scope)
                assert scopes[scope][:only] === [:index]
                assert scopes[scope][:using] === [:from, :to] if virtual.is_a?(Virtuals::Calculation)
              end
            end

            (entity.has_one_associations + entity.has_one_through_associations).each do |association|
              scope = "by_#{association.name}".to_sym
              test "should have scope #{scope}" do
                assert scopes.include?(scope)
                assert scopes[scope][:only] === [:index]
              end
            end

            test "should get API index" do
              login as: :json
              get subclass.url_helper, headers: authorization_header, as: :json
              assert_response :success
            end

            test "should get index" do
              login
              get subclass.url_helper
              assert_response :success
            end

            test "should get new" do
              login
              get subclass.url_helper(param: 'new')
              assert_response :success
            end

            test "should show API #{subclass.entity_name}" do
              login as: :json
              get subclass.url_helper(param: @record.id), headers: authorization_header, as: :json
              assert_response :success
            end

            test "should show #{subclass.entity_name}" do
              login
              get subclass.url_helper(param: @record.id)
              assert_response :success
            end

            test "should throw API #{subclass.entity_name} not found" do
              login as: :json
              get subclass.url_helper(param: 0), headers: authorization_header, as: :json
              assert_response :not_found
            end

            test "should throw #{subclass.entity_name} not found" do
              login
              get subclass.url_helper(param: 0)
              assert_response :not_found
            end

            test "should really destroy API #{subclass.entity_name}" do
              assert_difference("#{subclass.model_name}.count", -1) do
                login as: :json
                delete subclass.url_helper(param: @record.id),
                       headers: authorization_header,
                       params: { really: true },
                       as: :json
              end
              assert_response :no_content
            end

            test "should really destroy #{subclass.entity_name}" do
              assert_difference("#{subclass.model_name}.count", -1) do
                login
                delete subclass.url_helper(param: @record.id), params: { really: true }
              end
              assert_redirected_to subclass.url_helper
            end

            test "should unarchive API #{subclass.entity_name}" do
              @record.destroy
              assert @record.deleted?
              assert_difference("#{subclass.model_name}.count") do
                login as: :json
                delete subclass.url_helper(param: @record.id), headers: authorization_header, as: :json
              end
              assert_response :no_content
            end

            test "should unarchive #{subclass.entity_name}" do
              @record.destroy
              assert @record.deleted?
              assert_difference("#{subclass.model_name}.count") do
                login
                delete subclass.url_helper(param: @record.id)
              end
              assert_redirected_to subclass.url_helper
            end

            test "should archive API #{subclass.entity_name}" do
              @record.restore
              refute @record.deleted?
              assert_difference("#{subclass.model_name}.count", -1) do
                login as: :json
                delete subclass.url_helper(param: @record.id), headers: authorization_header, as: :json
              end
              assert_response :no_content
            end

            test "should archive #{subclass.entity_name}" do
              @record.restore
              refute @record.deleted?
              assert_difference("#{subclass.model_name}.count", -1) do
                login
                delete subclass.url_helper(param: @record.id)
              end
              assert_redirected_to subclass.url_helper
            end

            test "should update API #{subclass.entity_name}" do
              login as: :json
              patch subclass.url_helper(param: @record.id),
                    params: { subclass.entity_name.to_sym => @json_params },
                    headers: authorization_header,
                    as: :json
              assert_response :no_content
            end

            test "should update #{subclass.entity_name}" do
              login
              patch subclass.url_helper(param: @record.id),
                    params: { subclass.entity_name.to_sym => @params }
              assert_redirected_to subclass.url_helper(param: @record.reload.slug)
            end

            test "should create API #{subclass.entity_name}" do
              assert_difference("#{subclass.model_name}.count") do
                login as: :json
                post subclass.url_helper,
                     params: { subclass.entity_name.to_sym => @json_params },
                     headers: authorization_header,
                     as: :json
              end
              assert_response :created
            end

            test "should create #{subclass.entity_name}" do
              assert_difference("#{subclass.model_name}.count") do
                login
                post subclass.url_helper, params: { subclass.entity_name.to_sym => @params }
              end
              assert_redirected_to subclass.url_helper(param: subclass.model_name.constantize.last.slug)
            end
          end
        end
      end

      protected

      def login(as: nil)
        post '/sessions', params: { email: users(:two).email, password: "secret" }, as: as
      end

      def authorization_header
        { Authorization: JSON.parse(@response.body)['authToken'] }
      end

      def self.controller_name
        name.chomp('Test')
      end

      def self.model_name
        name.chomp('ControllerTest').singularize
      end

      def self.entity_name
        model_name.underscore
      end

      def self.fixture_name
        entity_name.pluralize
      end

      def self.url_helper(param: nil)
        [fixture_name, param].compact.join('/').prepend('/')
      end
    end
  end
end
