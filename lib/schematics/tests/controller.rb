module Schematics
  module Tests
    class Controller < ::ActionDispatch::IntegrationTest
      delegate :controller_class, to: :class
      delegate :model_class, to: :controller_class
      delegate :entity, to: :model_class

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

            entity.attributes.select(&:visible?).each do |attribute|
              scope = :"by_#{attribute.name}"
              test "should have scope #{scope}" do
                assert scopes.include?(scope)
                assert scopes[scope][:only] === [:index]
                assert scopes[scope][:using] === [:from, :to] if attribute.is_a?(Attributes::Date)
                assert scopes[scope][:type] === :boolean if attribute.is_a?(Attributes::Boolean)
              end
            end

            entity.virtuals.each do |virtual|
              scope = :"by_#{virtual.name}"
              test "should have scope #{scope}" do
                assert scopes.include?(scope)
                assert scopes[scope][:only] === [:index]
                assert scopes[scope][:using] === [:from, :to] if virtual.is_a?(Virtuals::Calculation)
              end
            end

            (entity.has_one_associations + entity.has_one_through_associations).each do |association|
              scope = :"by_#{association.name}"
              test "should have scope #{scope}" do
                assert scopes.include?(scope)
                assert scopes[scope][:only] === [:index]
              end
            end

            test "should get API index" do
              login as: :json
              get url_helper, headers: authorization_header, as: :json
              assert_response :success
            end

            test "should get index" do
              login
              get url_helper
              assert_response :success
            end

            test "should get new" do
              login
              get url_helper(param: 'new')
              assert_response :success
            end

            test "should show API #{entity.type}" do
              login as: :json
              get url_helper(param: @record.id), headers: authorization_header, as: :json
              assert_response :success
            end

            test "should show #{entity.type}" do
              login
              get url_helper(param: @record.id)
              assert_response :success
            end

            test "should throw API #{entity.type} not found" do
              login as: :json
              get url_helper(param: 0), headers: authorization_header, as: :json
              assert_response :not_found
            end

            test "should throw #{entity.type} not found" do
              login
              get url_helper(param: 0)
              assert_response :not_found
            end

            test "should really destroy API #{entity.type}" do
              assert_difference("#{model_class.name}.count", -1) do
                login as: :json
                delete url_helper(param: @record.id),
                       headers: authorization_header,
                       params: { really: true },
                       as: :json
              end
              assert_response :no_content
            end

            test "should really destroy #{entity.type}" do
              assert_difference("#{model_class.name}.count", -1) do
                login
                delete url_helper(param: @record.id), params: { really: true }
              end
              assert_redirected_to url_helper
            end

            test "should unarchive API #{entity.type}" do
              @record.destroy
              assert @record.deleted?
              assert_difference("#{model_class.name}.count") do
                login as: :json
                delete url_helper(param: @record.id), headers: authorization_header, as: :json
              end
              assert_response :no_content
            end

            test "should unarchive #{entity.type}" do
              @record.destroy
              assert @record.deleted?
              assert_difference("#{model_class.name}.count") do
                login
                delete url_helper(param: @record.id)
              end
              assert_redirected_to url_helper
            end

            test "should archive API #{entity.type}" do
              @record.restore
              refute @record.deleted?
              assert_difference("#{model_class.name}.count", -1) do
                login as: :json
                delete url_helper(param: @record.id), headers: authorization_header, as: :json
              end
              assert_response :no_content
            end

            test "should archive #{entity.type}" do
              @record.restore
              refute @record.deleted?
              assert_difference("#{model_class.name}.count", -1) do
                login
                delete url_helper(param: @record.id)
              end
              assert_redirected_to url_helper
            end

            test "should update API #{entity.type}" do
              login as: :json
              patch url_helper(param: @record.id),
                    params: { entity.type.to_sym => @json_params },
                    headers: authorization_header,
                    as: :json
              assert_response :no_content
            end

            test "should update #{entity.type}" do
              login
              patch url_helper(param: @record.id),
                    params: { entity.type.to_sym => @params }
              assert_redirected_to url_helper(param: @record.reload.slug)
            end

            test "should create API #{entity.type}" do
              assert_difference("#{model_class.name}.count") do
                login as: :json
                post url_helper,
                     params: { entity.type.to_sym => @json_params },
                     headers: authorization_header,
                     as: :json
              end
              assert_response :created
            end

            test "should create #{entity.type}" do
              assert_difference("#{model_class.name}.count") do
                login
                post url_helper, params: { entity.type.to_sym => @params }
              end
              assert_redirected_to url_helper(param: model_class.last.slug)
            end
          end
        end

        def controller_class
          name.chomp('Test').constantize
        end
      end

      protected

      def login(as: nil)
        post '/sessions', params: { email: users(:two).email, password: "secret" }, as: as
      end

      def authorization_header
        { Authorization: JSON.parse(@response.body)['authToken'] }
      end

      def url_helper(param: nil)
        [entity.type.pluralize, param].compact.join('/').prepend('/')
      end
    end
  end
end
