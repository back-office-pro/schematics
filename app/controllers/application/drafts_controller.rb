# frozen_string_literal: true

module Application
  module DraftsController
    extend ActiveSupport::Concern

    prepended do
      after_action :touch_session!, only: :update # rubocop:disable Rails/LexicallyScopedActionFilter
    end
  end
end
