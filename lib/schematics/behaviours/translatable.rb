# frozen_string_literal: true

module Schematics
  module Behaviours
    module Translatable
      delegate :translated?, to: :options

      def permitted_params
        return super unless translated?

        %i[en fr].map { :"#{name}_#{_1}" }
      end

      def to_str
        return super unless translated?

        super + <<~RUBY
          translates :#{name}
        RUBY
      end
    end
  end
end
