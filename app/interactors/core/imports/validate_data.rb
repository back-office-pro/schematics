# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Imports
    class ValidateData
      include Schematics::Progressable

      delegate :import, :data, :fail!, to: :context, private: true
      delegate :model_class, to: :import, private: true

      progressable import: 90

      before { @errors = Concurrent::Hash.new }

      # :reek:UncommunicativeVariableName
      def call
        context.data = data.flat_map do |line, attributes|
          resource = model_class.new(attributes)
          resource.validate!
          resource
            .attributes
            .symbolize_keys
            .compact
        rescue StandardError => e
          @errors[line] = e
        ensure
          update_progress!(line.to_f / data.size * self.class.progress)
        end
        fail!(errors: @errors) if @errors.any?
      end
    end
  end
end
