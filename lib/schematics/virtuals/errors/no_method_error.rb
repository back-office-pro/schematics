# frozen_string_literal: true

module Schematics
  module Virtuals
    module Errors
      class NoMethodError < NameError
        def name = super
          .to_s
          .chomp('_formatted')

        def to_s
          return super if receiver

          translate('errors.virtuals.nil')
        end
      end
    end
  end
end
