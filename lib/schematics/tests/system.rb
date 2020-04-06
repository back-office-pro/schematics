module Schematics
  module Tests
    class System < ::ApplicationSystemTestCase
      class << self
        delegate :entity, :fixture_name, :entity_name, to: :model_class

        def inherited(subclass)
          super
          subclass.class_eval do
            setup do
              @record = send(subclass.fixture_name, :one)
            end

            test "visiting the index" do
              visit(subclass.fixture_name)
              assert_selector("h1", text: entity_name.pluralize.titleize)
            end

            test "creating a #{entity_name}" do
              visit(subclass.fixture_name)
              click_on("New #{entity_name.titleize}")
              fill_form(entity)
              click_on("Create #{entity_name.humanize}")
              assert_text("#{entity_name.humanize} was successfully created")
              click_on("Back")
            end

            test "updating a #{entity_name}" do
              visit(subclass.fixture_name)
              click_on("Edit", match: :first)
              fill_form(entity)
              click_on("Update #{entity_name.humanize}")
              assert_text("#{entity_name.humanize} was successfully updated")
              click_on("Back")
            end

            test "destroying a #{entity_name}" do
              visit(subclass.fixture_name)
              page.accept_confirm { click_on "Destroy", match: :first }
              assert_text("#{entity_name.humanize} was successfully destroyed")
            end
          end
        end

        protected

        def model_class
          name.chomp('Test').singularize.constantize
        end

        def fill_form(entity)
          entity.attributes.each do |attribute|
            if attribute.is_a?(Attributes::Boolean)
              check(attribute.name.humanize) if @record.send(attribute.name)
            elsif attribute.is_a?(Attributes::Attachment)
              attach_file(attribute.name.humanize, attribute.default)
            elsif attribute.is_a?(Attributes::BelongsTo)
              select(@record.instance_eval("#{attribute.name}.#{attribute.inverse_descriptor.name}"),
                     from: attribute.name.humanize)
            else
              fill_in(attribute.name.humanize, with: attribute.default || @record.send(attribute.name))
            end
          end
        end
      end
    end
  end
end
