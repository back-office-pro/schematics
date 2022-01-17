# frozen_string_literal: true

module Schematics
  module Interactable
    extend ActiveSupport::Concern

    included do
      include Interactor

      before do
        context.message = '.success'
      end
    end

    def fail!(message: '.failure')
      context.fail!(message:)
    end
  end
end
