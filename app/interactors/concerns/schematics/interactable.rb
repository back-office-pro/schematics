# frozen_string_literal: true

module Schematics
  module Interactable
    extend ActiveSupport::Concern

    included do
      include Interactor

      before { context.message = '.success' }
    end

    def fail!(message: '.failure')
      context.fail!(message:)
    end
  end
end
