# frozen_string_literal: true

module Schematics
  module DocumentElement
    class Component < ApplicationComponent
      delegate :locale, to: ::I18n

      def theme = preferences(:theme, 'auto')
    end
  end
end
