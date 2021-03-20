module Schematics
  module Tests
    class Model < ::ActiveSupport::TestCase
      delegate :model_class, to: :class, private: true
      delegate :entity, to: :model_class, private: true

      class << self
        delegate :entity, to: :model_class, private: true

        def inherited(subclass)
          super
          subclass.class_eval do
            test_valid?
            test_required?
            test_unique?
            test_attachment_required?
            test_date_attributes
            test_digest_attributes
            test_enum_attributes
            test_float_attributes
            test_integer_attributes
            test_elements
            test_association_attributes
            test_has_many_associations
            test_has_one_associations
            test_has_many_through_associations
            test_has_one_through_associations
            test_has_and_belongs_to_many_associations
          end
        end

        def model_class
          name.chomp('Test').constantize
        end

        def test_valid?
          test "valid #{entity.name}" do
            assert record.valid?
          end
        end

        def test_required?
          entity.attributes.select(&:required?).each do |attribute|
            test "invalid without #{attribute.name}" do
              record.send("#{attribute.name}=", nil)
              refute record.valid?
              assert_not_nil record.errors[attribute.name.to_sym]
            end
          end
        end

        def test_unique?
          entity.attributes.select(&:unique?).each do |attribute|
            test "invalid without unique #{attribute.name}" do
              record.send("#{attribute.name}=", other_record.send(attribute.name))
              refute record.valid?
              assert_not_nil record.errors[attribute.name.to_sym]
            end

            test "#{attribute} should be required when unique" do
              assert attribute.required?
            end
          end
        end

        def test_attachment_required?
          entity.attachment_attributes.select(&:required?).each do |attachment|
            test "#{attachment.name} should have attached validator" do
              assert attachment.validators[:attached]
            end
          end
        end

        def test_date_attributes
          entity.date_attributes.each do |date|
            test "#{date.name} should have allow_blank validator" do
              assert date.validators[:date][:allow_blank] == !date.required?
            end
          end
        end

        def test_digest_attributes
          entity.digest_attributes.each do |digest|
            test "#{digest.name} should have allow_nil validator" do
              assert digest.validators[:allow_nil]
            end
          end
        end

        def test_enum_attributes
          entity.enum_attributes.each do |enum|
            test "#{enum.name} should have inclusion validator" do
              keys = model_class.send(enum.name.pluralize.to_sym).keys
              assert enum.validators[:inclusion][:in] == keys
            end
            enum.values.each do |value| # rubocop:disable Style/HashEachMethods
              test "should have enum value #{enum.name}_#{value}" do
                assert model_class.respond_to?(:"#{enum.name}_#{value}")
              end
            end
          end
        end

        def test_float_attributes
          entity.float_attributes.each do |float|
            test "#{float.name} should have numericality validator" do
              assert float.validators[:numericality][:allow_nil] == !float.required?
            end
          end
        end

        def test_integer_attributes
          entity.integer_attributes.each do |integer|
            test "#{integer.name} should have numericality validator" do
              assert integer.validators[:numericality][:only_integer]
            end
          end
        end

        def test_elements
          entity.elements.each do |element|
            test "should have element #{element.name}" do
              assert record.respond_to?(element.name.to_sym)
            end
          end
        end

        def test_association_attributes
          entity.association_attributes.each do |attribute|
            test "should belongs_to #{attribute.name}" do
              reflection = model_class.reflect_on_association(attribute.name.to_sym)
              assert reflection.macro == :belongs_to
              assert reflection.class_name == attribute.class_name
              assert reflection.foreign_key == attribute.column_name
              assert reflection.options[:inverse_of] == attribute.inverse_association.name.to_sym
              assert reflection.options[:optional] == true unless attribute.required?
            end
          end
        end

        def test_has_many_associations
          entity.has_many_associations.each do |association|
            test "should have many #{association.name}" do
              reflection = model_class.reflect_on_association(association.name.to_sym)
              assert reflection.macro == association.type.to_sym
              assert reflection.class_name == association.class_name
              assert reflection.foreign_key == association.column_name
              assert reflection.options[:inverse_of] == association.belongs_to.name.to_sym
              assert reflection.options[:dependent] == association.required? ? :destroy : :nullify
            end
          end
        end

        def test_has_one_associations
          entity.has_one_associations.each do |association|
            test "should have one #{association.name}" do
              reflection = model_class.reflect_on_association(association.name.to_sym)
              assert reflection.macro == association.type.to_sym
              assert reflection.class_name == association.class_name
              assert reflection.foreign_key == association.column_name
              assert reflection.options[:inverse_of] == association.belongs_to.name.to_sym
            end
          end
        end

        def test_has_many_through_associations
          entity.has_many_through_associations.each do |association|
            test "should have many #{association.name} through #{association.through.name}" do
              reflection = model_class.reflect_on_association(association.name.to_sym)
              assert reflection.macro == association.type.to_sym
              assert reflection.class_name == association.class_name
              assert reflection.foreign_key == association.column_name
              assert reflection.options[:through] == association.through.name.to_sym
            end
          end
        end

        def test_has_one_through_associations
          entity.has_one_through_associations.each do |association|
            test "should have one #{association.name} through #{association.through.name}" do
              reflection = model_class.reflect_on_association(association.name.to_sym)
              assert reflection.macro == association.type.to_sym
              assert reflection.class_name == association.class_name
              assert reflection.foreign_key == association.column_name
              assert reflection.options[:through] == association.through.name.to_sym
            end
          end
        end

        def test_has_and_belongs_to_many_associations
          entity.has_and_belongs_to_many_associations.each do |association|
            test "should have and belongs to many #{association.name}" do
              reflection = model_class.reflect_on_association(association.name.to_sym)
              assert reflection.macro == association.type.to_sym
            end
          end
        end
      end

      protected

      def record
        @record ||= send(entity.name.pluralize, :one)
      end

      def other_record
        @other_record ||= send(entity.name.pluralize, :two)
      end
    end
  end
end
