# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'

module Schematics
  module Virtuals
    module Errors
      class NameError
        delegate_missing_to :@exception
        delegate :translate, to: :I18n

        def initialize(exception)
          @exception = exception
        end

        def to_s
          translate('errors.virtuals.name', variable: name)
        end
      end
    end
  end
end
