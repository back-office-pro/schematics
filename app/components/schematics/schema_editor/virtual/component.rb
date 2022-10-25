# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Virtual
      class Component < ApplicationComponent
        delegate :icon, to: 'builder.object'
        renders_one_form :builder
        option :builder

        def title = t('.title')
      end
    end
  end
end
