# frozen_string_literal: true

module Schematics
  module Entitleable
    extend ActiveSupport::Concern

    included do
      helper_method :title
    end

    def title
      t(action_name, scope: [:titles, i18n_title_path], default: nil, **view_assigns) ||
        t(action_name, scope: %i[titles schematics resources], **view_assigns)
    end

    private

    def i18n_title_path = controller_path.tr('/', '.')

    def view_assigns = super.symbolize_keys
  end
end
