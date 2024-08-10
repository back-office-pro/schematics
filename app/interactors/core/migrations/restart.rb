# frozen_string_literal: true

module Core
  module Migrations
    class Restart
      include Interactor
      delegate :force, to: :context, private: true

      def call
        return unless ::Tenant.search_engine.indexable? || force

        FileUtils.touch ::Rails.root.join('tmp/restart.txt')
      end
    end
  end
end
