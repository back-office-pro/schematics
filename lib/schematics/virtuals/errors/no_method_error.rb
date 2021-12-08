# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'

module Schematics
  module Virtuals
    module Errors
      class NoMethodError
        delegate_missing_to :@exception
        delegate :translate, to: :I18n

        def initialize(exception)
          @exception = exception
        end

        def to_s
          return translate('errors.virtuals.nil') unless receiver

          translate('errors.virtuals.no_method', name: method_name)
        end

        private

        def method_name
          name.to_s.chomp('_formatted')
        end
      end
    end
  end
end
