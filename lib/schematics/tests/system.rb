module Schematics
  module Tests
    class System < ::ApplicationSystemTestCase
      class << self
        def inherited(subclass)
          super
          subclass.class_eval do
            setup do
              @record = send(subclass.fixture_name, :one)
            end
          
            entity = SCHEMA.find_entity_by_type(subclass.entity_name)
            
            test "visiting the index" do
              visit subclass.fixture_name
              assert_selector "h1", text: subclass.model_name.pluralize.titleize
            end

            test "creating a #{subclass.entity_name}" do
              visit subclass.fixture_name
              click_on "New #{subclass.model_name.titleize}"
              fill_form(entity)
              click_on "Create #{subclass.entity_name.humanize}"
              assert_text "#{subclass.entity_name.humanize} was successfully created"
              click_on "Back"
            end

            test "updating a #{subclass.entity_name}" do
              visit subclass.fixture_name
              click_on "Edit", match: :first
              fill_form(entity)
              click_on "Update #{subclass.entity_name.humanize}"
              assert_text "#{subclass.entity_name.humanize} was successfully updated"
              click_on "Back"
            end

            test "destroying a #{subclass.entity_name}" do
              visit subclass.fixture_name
              page.accept_confirm { click_on "Destroy", match: :first }
              assert_text "#{subclass.entity_name.humanize} was successfully destroyed"
            end

            def fill_form(entity)
              entity.attributes.each do |attribute|
                if attribute.is_a?(Attributes::Boolean)
                  check attribute.name.humanize if @record.send(attribute.name)
                elsif attribute.is_a?(Attributes::Attachment)
                  attach_file attribute.name.humanize, Rails.root.join('public', 'apple-touch-icon.png')
                elsif attribute.is_a?(Attributes::BelongsTo)
                  select @record.instance_eval("#{attribute.name}.#{attribute.inverse_descriptor.name}"), from: attribute.name.humanize
                else
                  fill_in attribute.name.humanize, with: attribute.unique? ? SecureRandom.base58 : @record.send(attribute.name)
                end
              end
            end
          end
        end
      end

      protected

      def self.model_name
        self.name.chomp('Test').singularize
      end

      def self.entity_name
        self.model_name.underscore
      end

      def self.fixture_name
        self.entity_name.pluralize
      end
    end
  end
end
