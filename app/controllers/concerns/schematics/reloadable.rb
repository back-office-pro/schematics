# frozen_string_literal: true

module Schematics
  module Reloadable
    extend ActiveSupport::Concern

    included do
      prepend_before_action :reload!
    end

    private

    def reload!
      return unless Rails.cache.read('reload')

      Rails.cache.delete('reload')
      Core::Migrations::Reload.call(migration: Migration.current)
    end
  end
end
