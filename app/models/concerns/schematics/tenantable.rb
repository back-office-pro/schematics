# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Tenantable
    extend ActiveSupport::Concern

    included do
      delegate :name, to: :class, prefix: true, private: true
      delegate :current_shard, to: :class
    end

    class_methods do
      def demo? = current_shard
        .to_sym
        .eql?(:demo)
    end
  end
end
