# frozen_string_literal: true

module Schematics
  module Footer
    module Network
      class Component < ApplicationComponent
        def offline_css_classes = %w[
          d-none
          text-danger
          animate__animated
          animate__pulse
          animate__slower
          animate__infinite
        ]
      end
    end
  end
end
