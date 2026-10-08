# frozen_string_literal: true

module Schematics
  module Triggers
    module Errors
      class NoMethodError < NameError
        def name = super
          .to_s
          .chomp('_formatted')

        def to_s
          return super if receiver

          translate('errors.triggers.nil')
        end
      end
    end
  end
end
