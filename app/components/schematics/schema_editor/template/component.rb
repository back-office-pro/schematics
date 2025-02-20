# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Template
      class Component < ApplicationComponent
        option :form

        def entity = Entities::Entity.new(schema:, id: 'RANDOM_UUID')

        def schema = form.object
      end
    end
  end
end
