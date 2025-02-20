# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module HasMany
        module Button
          module Remove
            class Component < ApplicationComponent
              delegate :entity, :name, to: :field, private: true
              delegate :model_class, to: :entity, private: true
              delegate :human_name, :gender, to: :model_class

              option :field

              def wrapper = ".nested-association-#{name}"
            end
          end
        end
      end
    end
  end
end
