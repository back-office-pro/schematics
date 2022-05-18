# frozen_string_literal: true

module Schematics
  module Associations
    class HasAndBelongsToMany < Association
      include Behaviours::Fillable

      def column_name
        super.pluralize
      end

      def permitted_params
        { super => [] }
      end

      def source
        inverse_of.pluralize
      end

      def to_str = <<~RUBY
        #{type} :#{name}
      RUBY
    end
  end
end
