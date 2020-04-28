module Schematics
  module Tests
    class Model < ::ActiveSupport::TestCase
      delegate :model_class, to: :class
      delegate :entity, to: :model_class

      class << self
        delegate :entity, to: :model_class

        def inherited(subclass)
          super
          subclass.class_eval do
            setup do
              @record = send(entity.type.pluralize, :one)
              @other_record = send(entity.type.pluralize, :two)
            end

            test "valid #{entity.type}" do
              assert @record.valid?
            end

            entity.filterable_elements.each do |element|
              scope = :"by_#{element.name}"
              test "should have filter scope #{scope}" do
                assert model_class.respond_to?(scope)
              end
            end

            entity.sortable_elements.each do |element|
              scope = :"sort_by_#{element.name}"
              test "should have sort scope #{scope}" do
                assert model_class.respond_to?(scope)
              end
            end

            entity.attributes.select(&:required?).each do |attribute|
              test "invalid without #{attribute.name}" do
                @record.send("#{attribute.name}=", nil)
                refute @record.valid?
                assert_not_nil @record.errors[attribute.name.to_sym]
              end
            end

            entity.attributes.select(&:unique?).each do |attribute|
              test "invalid without unique #{attribute.name}" do
                @record.send("#{attribute.name}=", @other_record.send(attribute.name))
                refute @record.valid?
                assert_not_nil @record.errors[attribute.name.to_sym]
              end

              test "#{attribute} should be required when unique" do
                assert attribute.required?
              end
            end

            entity.attachment_attributes.select(&:required?).each do |attachment|
              test "#{attachment.name} should have attached validator" do
                assert attachment.validators[:attached]
              end
            end

            entity.date_attributes.each do |date|
              test "#{date.name} should have allow_blank validator" do
                assert date.validators[:date][:allow_blank] == !date.required?
              end
            end

            entity.digest_attributes.each do |digest|
              test "#{digest.name} should have allow_nil validator" do
                assert digest.validators[:allow_nil]
              end
            end

            entity.enum_attributes.each do |enum|
              test "#{enum.name} should have inclusion validator" do
                keys = model_class.send(enum.name.pluralize.to_sym).keys
                assert enum.validators[:inclusion][:in] == keys
              end
              enum.values.each do |value|
                test "should have enum value #{enum.name}_#{value}" do
                  assert model_class.respond_to?(:"#{enum.name}_#{value}")
                end
              end
            end

            entity.float_attributes.each do |float|
              test "#{float.name} should have numericality validator" do
                assert float.validators[:numericality][:allow_nil] == !float.required?
              end
            end

            entity.integer_attributes.each do |integer|
              test "#{integer.name} should have numericality validator" do
                assert integer.validators[:numericality][:only_integer]
              end
            end

            (entity.fields - entity.digest_attributes).each do |field|
              test "should have field #{field.name}" do
                assert @record.respond_to?(field.name.to_sym)
              end
            end

            entity.association_attributes.each do |attribute|
              test "should belongs_to #{attribute.name}" do
                reflection = model_class.reflect_on_association(attribute.name.to_sym)
                assert reflection.macro == :belongs_to
                assert reflection.class_name == attribute.model_property_type
                assert reflection.options[:optional] == true unless attribute.required?
              end
            end

            entity.has_many_associations.each do |association|
              test "should have many #{association.name}" do
                reflection = model_class.reflect_on_association(association.name.to_sym)
                assert reflection.macro == :has_many
                assert reflection.class_name == association.class_name
                assert reflection.options[:dependent] == association.required? ? :destroy : :nullify
              end
            end

            entity.has_one_associations.each do |association|
              test "should have one #{association.name}" do
                reflection = model_class.reflect_on_association(association.name.to_sym)
                assert reflection.macro == :has_one
                assert reflection.class_name == association.class_name
              end
            end

            entity.has_many_through_associations.each do |association|
              test "should have many #{association.name} through #{association.through.name}" do
                reflection = model_class.reflect_on_association(association.name.to_sym)
                assert reflection.macro == :has_many
                assert reflection.class_name == association.class_name
                assert reflection.options[:through] == association.through.name.to_sym
              end
            end

            entity.has_one_through_associations.each do |association|
              test "should have one #{association.name} through #{association.through.name}" do
                reflection = model_class.reflect_on_association(association.name.to_sym)
                assert reflection.macro == :has_one
                assert reflection.class_name == association.class_name
                assert reflection.options[:through] == association.through.name.to_sym
              end
            end
          end
        end

        def model_class
          name.chomp('Test').constantize
        end
      end
    end
  end
end
