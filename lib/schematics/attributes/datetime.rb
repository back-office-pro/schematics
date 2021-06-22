# frozen_string_literal: true

require 'schematics/attributes/date'

module Schematics
  module Attributes
    class Datetime < Date
      def format(value)
        value && I18n.l(value, format: '%A %d %B %Y %H:%M')
      end

      def default
        return ::Time.current.yesterday.to_s(:db) if options.before
        return ::Time.current.tomorrow.to_s(:db) if options.after

        super
      end
    end
  end
end
