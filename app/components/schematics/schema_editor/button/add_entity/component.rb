# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Button
      module AddEntity
        class Component < ApplicationComponent
          def render? = !::Licence
            .instance
            .quota_entities_exceeded?
        end
      end
    end
  end
end
