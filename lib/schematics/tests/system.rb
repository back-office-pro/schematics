module Schematics
  module Tests
    class System < ::ApplicationSystemTestCase
      delegate :model_class, to: :class
      delegate :entity, to: :model_class

      class << self
        delegate :entity, to: :model_class

        def inherited(subclass)
          super
          subclass.class_eval do
            setup do
              @record = send(entity.type.pluralize, :one)
            end

            test "visiting the index" do
              visit(entity.type.pluralize)
              assert_selector("h1", text: entity.type.pluralize.titleize)
            end

            test "creating a #{entity.type}" do
              visit(entity.type.pluralize)
              click_on("New #{entity.type.titleize}")
              fill_form(entity)
              click_on("Create #{entity.type.humanize}")
              assert_text("#{entity.type.humanize} was successfully created")
              click_on("Back")
            end

            test "updating a #{entity.type}" do
              visit(entity.type.pluralize)
              click_on("Edit", match: :first)
              fill_form(entity)
              click_on("Update #{entity.type.humanize}")
              assert_text("#{entity.type.humanize} was successfully updated")
              click_on("Back")
            end

            test "destroying a #{entity.type}" do
              visit(entity.type.pluralize)
              page.accept_confirm { click_on "Destroy", match: :first }
              assert_text("#{entity.type.humanize} was successfully destroyed")
            end
          end
        end

        def model_class
          name.chomp('Test').classify.constantize
        end
      end

      protected

      def fill_form(entity)
        entity.attributes.each do |attribute|
          if attribute.is_a?(Attributes::Boolean)
            check(attribute.name.humanize) if @record.send(attribute.name)
          elsif attribute.is_a?(Attributes::Attachment)
            attach_file(attribute.name.humanize, attribute.default)
          elsif attribute.is_a?(Attributes::BelongsTo)
            select @record.instance_eval("#{attribute.name}.#{attribute.inverse_descriptor.name}"),
                   from: attribute.name.humanize
          else
            fill_in attribute.name.humanize,
                    with: attribute.default || @record.send(attribute.name)
          end
        end
      end
    end
  end
end
