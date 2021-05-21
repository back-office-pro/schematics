# frozen_string_literal: true

require 'schematics/entities/entity'

module Schematics
  module Entities
    class Singleton < Entity
      def route
        <<~RUBY
          resource :#{name.pluralize}, only: [:show, :edit, :update]
          resolve("#{class_name}") { [:#{name.pluralize}] }
        RUBY
      end

      def to_str
        super + <<~RUBY # rubocop:disable Style/StringConcatenation
          acts_as_singleton
        RUBY
      end
    end
  end
end
