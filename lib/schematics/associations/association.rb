# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'active_model'
require 'active_support/core_ext/module/delegation'

module Schematics
  module Associations
    # :reek:Attribute
    class Association
      include Behaviours::Specifiable
      include Behaviours::Inspectable
      include Behaviours::Renderable
      include Behaviours::Preloadable
      include Behaviours::Documentable
      include Behaviours::Internationalizable
      include ::ActiveModel::API

      delegate :hidden?, to: :options
      delegate :entity,
               :inverse_entity,
               :inverse_association,
               :required?,
               :polymorphic?,
               :column_name,
               :association_type,
               :options,
               to: :belongs_to
      delegate :descriptor,
               :class_name,
               :model_class,
               :icon,
               :includes,
               :schema,
               :existing?,
               to: :entity
      attr_accessor :belongs_to

      class << self
        def build(type: 'has_many', entity: nil, belongs_to: nil, name: nil, options: nil)
          belongs_to ||= Attributes::BelongsTo.new(entity:, name:, options:)
          Associations.const_get(type.camelize.to_sym).new(belongs_to:)
        end

        def to_proc = -> { build(**it) }
      end

      def open_api_schema_type = [id: super, descriptor.name.to_sym => super]

      def weight = 3

      def name
        return [inverse_of, source].join('_') if prefixed?

        source
      end

      def source = belongs_to.inverse_association_name

      def inverse_of = belongs_to.name

      def to_str = scope_to_str.concat(association_to_str)

      protected

      def prefixed? = inverse_entity
        .associations
        .reject { it.belongs_to == belongs_to }
        .any? { it.source == source }

      def scope_to_str = <<~RUBY
        scope :with_#{name}, -> { includes(#{preload}) }
      RUBY

      def association_to_str = <<~RUBY.chomp
        #{type} :#{name},
                -> { with_deleted },
                class_name: '::#{class_name}',
                foreign_key: '#{column_name}'
      RUBY

      def spec_interpolations = super.merge(name:)
    end
  end
end
