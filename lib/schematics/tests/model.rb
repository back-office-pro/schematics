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
            end

            entity.virtuals.each do |virtual|
              test "should have virtual #{virtual.name}" do
                assert @record.respond_to?(virtual.name.to_sym)
                assert @record.send(virtual.name.to_sym)
              end
            end

            entity.references.each do |reference|
              test "should belongs_to #{reference.name}" do
                reflection = @record.class.reflect_on_association(reference.name.to_sym)
                assert reflection.macro === :belongs_to
                assert reflection.class_name === reference.model_property_type
                assert reflection.options[:optional] === true unless reference.required?
              end
            end

            entity.has_many_associations.each do |association|
              test "should have many #{association.name}" do
                reflection = @record.class.reflect_on_association(association.name.to_sym)
                assert reflection.macro === :has_many
                assert reflection.class_name === association.class_name
                assert reflection.options[:dependent] === association.required? ? :destroy : :nullify
              end
            end

            entity.has_one_associations.each do |association|
              test "should have one #{association.name}" do
                reflection = @record.class.reflect_on_association(association.name.to_sym)
                assert reflection.macro === :has_one
                assert reflection.class_name === association.class_name
              end
            end

            entity.has_many_through_associations.each do |association|
              test "should have many #{association.name} through #{association.through.name}" do
                reflection = @record.class.reflect_on_association(association.name.to_sym)
                assert reflection.macro === :has_many
                assert reflection.class_name === association.class_name
                assert reflection.options[:through] === association.through.name.to_sym
              end
            end

            entity.has_one_through_associations.each do |association|
              test "should have one #{association.name} through #{association.through.name}" do
                reflection = @record.class.reflect_on_association(association.name.to_sym)
                assert reflection.macro === :has_one
                assert reflection.class_name === association.class_name
                assert reflection.options[:through] === association.through.name.to_sym
              end
            end

            (entity.attributes + entity.virtuals + entity.has_one_associations + entity.has_one_through_associations).
              select(&:visible?).each do |scopable|
              scope = :"by_#{scopable.name}"
              test "should have scope #{scope}" do
                assert @record.class.respond_to?(scope)
              end
            end

            entity.attributes.select_is_a?(Attributes::Enum).each do |enum|
              test "should have enum #{enum.name}" do
                @record.respond_to?(enum.name.to_sym)
                enum.values.map(&:to_sym).each do |value|
                  assert @record.class.respond_to?(value)
                end
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
