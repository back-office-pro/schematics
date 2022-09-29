# frozen_string_literal: true

module Schematics
  module Imports
    class ValidateData
      include Interactor
      delegate :import, :data, to: :context, private: true
      delegate :model_class, to: :import, private: true

      before { @errors = Concurrent::Hash.new }

      # :reek:UncommunicativeVariableName
      def call
        context.data = data.flat_map do |line, attributes|
          resource = model_class.new(attributes)
          resource.validate!
          resource
            .attributes
            .compact
        rescue StandardError => e
          @errors[::I18n.t('.line', line:)] = e
        ensure
          import.update!(progress: (line / data.size) * 100)
        end
        context.fail!(errors: @errors) if @errors.any?
      end
    end
  end
end
