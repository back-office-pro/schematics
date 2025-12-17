# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Cacheable
    extend ActiveSupport::Concern

    included do
      cached_attributes.each do |attribute|
        define_singleton_method(attribute) do
          Rails.cache.fetch("#{model_name.singular}/#{attribute}") do
            instance.public_send(attribute)
          end
        rescue ActiveRecord::NoDatabaseError # cache database not yet available
          instance.public_send(attribute)
        end
      end
    end
  end
end
