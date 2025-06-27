# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Reloadable
    extend ActiveSupport::Concern

    included do
      before_action :reload!
    end

    private

    def reload!
      old_and_changed_model_classes = Rails.cache.read('old_and_changed_model_classes')
      return unless old_and_changed_model_classes

      Rails.cache.delete('old_and_changed_model_classes')
      Shards::Reload.call(old_and_changed_model_classes:)
    end
  end
end
