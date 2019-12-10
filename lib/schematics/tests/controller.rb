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
              @params = entity.attributes.map do |attribute|
                param = [attribute.column_name]
                attachment = fixture_file_upload(Rails.root.join('public', 'apple-touch-icon.png'), 'image/png')
                if attribute.unique?
                  param << SecureRandom.hex
                elsif attribute.is_a?(Attributes::Attachments)
                  param << [attachment]
                elsif attribute.is_a?(Attributes::Attachment)
                  param << attachment
                else
                  param << @record.send(attribute.column_name)
                end
              end.to_h
            end
          
            test "should have scope with_deleted" do
              assert scopes.include?(:with_deleted)
              assert scopes[:with_deleted][:only] === [:index]
              assert scopes[:with_deleted][:type] === :boolean
            end
            
            entity.attributes.each do |attribute|
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
              get subclass.url_helper, as: :json
              assert_response :success
            end

            test "should get index" do
              get subclass.url_helper
              assert_response :success
            end

            test "should get new" do
              get subclass.url_helper('new')
              assert_response :success
            end

            test "should show API #{subclass.entity_name}" do
              get subclass.url_helper(@record.id), as: :json
              assert_response :success
            end

            test "should show #{subclass.entity_name}" do
              get subclass.url_helper(@record.id)
              assert_response :success
            end

            test "should throw API #{subclass.entity_name} not found" do
              get subclass.url_helper(0), as: :json
              assert_response :not_found
            end

            test "should throw #{subclass.entity_name} not found" do
              get subclass.url_helper(0)
              assert_response :not_found
            end

            test "should really destroy API #{subclass.entity_name}" do
              assert_difference("#{subclass.model_name}.count", -1) do
                delete subclass.url_helper(@record.id), params: { really: true }, as: :json
              end
              assert_response :no_content
            end

            test "should really destroy #{subclass.entity_name}" do
              assert_difference("#{subclass.model_name}.count", -1) do
                delete subclass.url_helper(@record.id), params: { really: true }
              end
              assert_redirected_to subclass.url_helper
            end

            test "should unarchive API #{subclass.entity_name}" do
              @record.destroy
              assert @record.deleted?
              assert_difference("#{subclass.model_name}.count") do
                delete subclass.url_helper(@record.id), as: :json
              end
              assert_response :no_content
            end

            test "should unarchive #{subclass.entity_name}" do
              @record.destroy
              assert @record.deleted?
              assert_difference("#{subclass.model_name}.count") do
                delete subclass.url_helper(@record.id)
              end
              assert_redirected_to subclass.url_helper
            end

            test "should archive API #{subclass.entity_name}" do
              @record.restore
              refute @record.deleted?
              assert_difference("#{subclass.model_name}.count", -1) do
                delete subclass.url_helper(@record.id), as: :json
              end
              assert_response :no_content
            end

            test "should archive #{subclass.entity_name}" do
              @record.restore
              refute @record.deleted?
              assert_difference("#{subclass.model_name}.count", -1) do
                delete subclass.url_helper(@record.id)
              end
              assert_redirected_to subclass.url_helper
            end

            test "should update API #{subclass.entity_name}" do
              patch subclass.url_helper(@record.id), params: { subclass.entity_name.to_sym => @params }, as: :json
              assert_response :no_content
            end 

            test "should update #{subclass.entity_name}" do
              patch subclass.url_helper(@record.id), params: { subclass.entity_name.to_sym => @params }
              assert_redirected_to subclass.url_helper(@record.id)
            end

            test "should create API #{subclass.entity_name}" do
              assert_difference("#{subclass.model_name}.count") do
                post subclass.url_helper, params: { subclass.entity_name.to_sym => @params }, as: :json
              end
              assert_response :created
            end

            test "should create #{subclass.entity_name}" do
              assert_difference("#{subclass.model_name}.count") do
                post subclass.url_helper, params: { subclass.entity_name.to_sym => @params }
              end
              assert_redirected_to subclass.url_helper(subclass.model_name.constantize.first.id)
            end
          end
        end
      end

      protected
      
      def self.controller_name
        self.name.chomp('Test')
      end

      def self.model_name
        self.name.chomp('ControllerTest').singularize
      end

      def self.entity_name
        self.model_name.underscore
      end

      def self.fixture_name
        self.entity_name.pluralize
      end

      def self.url_helper(param = nil)
        [self.fixture_name, param].compact.join('/').prepend('/')
      end
    end
  end
end
