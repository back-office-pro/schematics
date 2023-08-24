# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Button
      module Add
        class Component < ApplicationComponent
          delegate :human_name, :gender, to: 'attribute.entity.model_class'
          option :attribute
        end
      end
    end
  end
end
