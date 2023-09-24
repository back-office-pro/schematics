# frozen_string_literal: true

module Core
  module Imports
    class ValidateData
      include Interactor

      delegate :import, :data, :fail!, to: :context, private: true
      delegate :model_class, to: :import, private: true

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
          @errors[::I18n.t('.line', line:)] = e
        ensure
          PaperTrail.request(enabled: false) do
            import.reload.update!(progress: (line / data.size) * 100)
          end
        end
        fail!(errors: @errors) if @errors.any?
      end
    end
  end
end
