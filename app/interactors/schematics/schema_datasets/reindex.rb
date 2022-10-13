# frozen_string_literal: true

module Schematics
  module SchemaDatasets
    class Reindex
      include Interactor
      delegate :app_env, to: 'Schematics::Engine', private: true

      def call
        system "RAILS_ENV=#{app_env} rails searchkick:reindex:all"
      end
    end
  end
end
