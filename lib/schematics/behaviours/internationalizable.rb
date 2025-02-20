# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Behaviours
    module Internationalizable
      def i18n_scope = :attributes

      def i18n_key
        [:activerecord, i18n_scope, entity.name, name].join('.')
      end
    end
  end
end
