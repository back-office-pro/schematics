# frozen_string_literal: true

module Schematics
  class ApplicationComponent < ViewComponent::Base
    include ViewComponent::Translatable

    delegate :fa_icon, :current_user, :current_ability, to: :helpers
  end
end
