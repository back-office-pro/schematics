# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Behaviours
    module Incrementable
      delegate :auto_increment?, to: :options

      def readonly?
        super || auto_increment?
      end

      def available_options = super.push(Options::AutoIncrement)

      def to_str
        return super unless auto_increment?

        super + <<~RUBY
          attribute :#{name}, default: -> { with_deleted.last&.#{name}.to_i.next }
        RUBY
      end
    end
  end
end
