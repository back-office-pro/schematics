# frozen_string_literal: true

module Schematics
  module Localizable
    extend ActiveSupport::Concern

    included do
      around_action :switch_localization
    end

    def switch_localization(&block) # rubocop:disable Naming/BlockForwarding
      ::I18n.with_locale(current_user.locale) do
        ::Time.use_zone(current_user.time_zone) do
          ::I18n.in_beginning_of_week(&block) # rubocop:disable Naming/BlockForwarding
        end
      end
    end
  end
end
