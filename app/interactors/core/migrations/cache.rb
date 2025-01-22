# frozen_string_literal: true

module Core
  module Migrations
    class Cache
      include Schematics::Progressable

      progressable migration: 70

      def call = ::Rails
        .cache
        .delete('schema')
    end
  end
end
