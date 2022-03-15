# frozen_string_literal: true

module Schematics
  module Imports
    class ValidateData
      include Interactor

      before do
        @import = context.import
        @model_class = context.model_class
        @data = context.data
        @errors = Concurrent::Hash.new
      end

      # :reek:UncommunicativeVariableName
      def call
        context.data = @data.flat_map do |line, attributes|
          resource = @model_class.new(attributes)
          resource.validate!
          resource
            .attributes
            .compact
            .merge('created_at' => ::Time.current, 'updated_at' => ::Time.current) # rubocop:disable Style/StringHashKeys
        rescue StandardError => e
          @errors[::I18n.t('.line', line:)] = e
        ensure
          @import.update!(progress: (line / @data.size) * 100)
        end
        context.fail!(errors: @errors) if @errors.any?
      end
    end
  end
end
