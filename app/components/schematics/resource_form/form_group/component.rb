# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module ResourceForm
    module FormGroup
      class Component < ApplicationComponent
        renders_one :body
        option :group
        option :resource

        def id = "collapse-#{group}"

        def icon = :square_check

        def title = t(group, scope:)

        private

        def scope = [
          :activerecord,
          :groups,
          resource.class.entity.table_name.to_sym
        ]
      end
    end
  end
end
