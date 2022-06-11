# frozen_string_literal: true

module Main
  class MainRecord < ::ApplicationRecord
    self.abstract_class = true

    include Schematics::Loadable
    include Schematics::Translatable
    include Schematics::Singleton

    connects_to database: { writing: :main, reading: :main }

    class << self
      def instance
        find_by(application:)
      end

      def application = Rails
        .application
        .class
        .module_parent_name
        .underscore
    end
  end
end
