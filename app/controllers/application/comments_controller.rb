# frozen_string_literal: true

module Application
  module CommentsController
    extend ActiveSupport::Concern

    prepended do
      include Schematics::Nestable
    end

    def resource_defaults
      super.merge(record:)
    end
  end
end
