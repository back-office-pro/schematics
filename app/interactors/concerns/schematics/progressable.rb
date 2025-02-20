# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Progressable
    extend ActiveSupport::Concern

    included do
      include Interactor

      after :update_progress!
    end

    class_methods do
      # :reek:Attribute
      attr_accessor :resource_name, :progress

      def progressable(options)
        self.resource_name, self.progress = options.first
      end
    end

    def update_progress!(progress = self.class.progress)
      resource.reload.update!(progress:) if resource&.persisted?
    end

    private

    def resource
      context.public_send(self.class.resource_name)
    end
  end
end
