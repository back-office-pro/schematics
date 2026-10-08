# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Errors
      class Component < ApplicationComponent
        option :errors

        def messages = errors
          .full_messages
          .to_sentence

        def render?
          errors.any?
        end
      end
    end
  end
end
