# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'
require 'active_model'

module Schematics
  module Associations
    # :reek:Attribute
    class Association
      include Behaviours::Inspectable
      include Behaviours::Renderable
      include Behaviours::Preloadable
      include ::ActiveModel::API

      delegate :entity, :required?, :column_name, :association_type, :options, to: :belongs_to
      delegate :descriptor, :class_name, :icon, to: :entity
      delegate :hidden?, to: :options
      attr_accessor :belongs_to, :prefixed

      validates :name, presence: true

      class << self
        def build(type: 'has_many', entity: nil, belongs_to: nil, name: nil)
          belongs_to ||= Attributes::BelongsTo.new(entity:, name:, options: { required: true })
          Associations.const_get(type.camelize.to_sym).new(belongs_to:)
        end
      end

      def open_api_type = [{ id!: ::String }]

      def weight = 3

      def name
        return [inverse_of, source].join('_') if prefixed

        source
      end

      def source = belongs_to.inverse_association_name

      def inverse_of = belongs_to.name

      def to_str = <<~RUBY.chomp
        #{type} :#{name},
                class_name: '#{class_name}',
                foreign_key: '#{column_name}'
      RUBY
    end
  end
end
