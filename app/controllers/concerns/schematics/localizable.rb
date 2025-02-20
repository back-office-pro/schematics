# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Localizable
    extend ActiveSupport::Concern

    included do
      around_action :switch_localization
    end

    private

    def switch_localization(&)
      ::I18n.with_locale(current_user.locale) do
        ::Time.use_zone(current_user.time_zone) do
          ::I18n.in_beginning_of_week(&)
        end
      end
    end
  end
end
