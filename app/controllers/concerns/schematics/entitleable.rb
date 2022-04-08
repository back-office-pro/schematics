# frozen_string_literal: true

module Schematics
  module Entitleable
    extend ActiveSupport::Concern

    included do
      helper_method :title
    end

    def title
      t(action_name, scope: [:titles, title_path], **view_assigns.symbolize_keys)
    end

    def title_path
      controller_path.tr('/', '.')
    end
  end
end
