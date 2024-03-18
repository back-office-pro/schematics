# frozen_string_literal: true

module Core
  module Migrations
    class Restart
      include Interactor

      def call
        FileUtils.touch ::Rails.root.join('tmp/restart.txt')
      end
    end
  end
end
