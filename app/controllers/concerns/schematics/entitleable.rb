# frozen_string_literal: true

module Schematics
  module Entitleable
    extend ActiveSupport::Concern

    included do
      helper_method :title
    end

    def title = translate(
      action_name,
      scope: [:titles, i18n_title_path],
      **view_assigns.symbolize_keys
    )

    private

    def i18n_title_path = controller_path.tr('/', '.')
  end
end
