# frozen_string_literal: true

module Schematics
  module Localizable
    extend ActiveSupport::Concern

    included do
      around_action :switch_locale
      around_action :switch_beginning_of_week
      around_action :switch_time_zone
    end

    def switch_beginning_of_week(&)
      ::I18n.in_beginning_of_week(&)
    end

    def switch_locale(&)
      ::I18n.with_locale(current_user.locale, &)
    end

    def switch_time_zone(&)
      ::Time.use_zone(current_user.time_zone, &)
    end
  end
end
