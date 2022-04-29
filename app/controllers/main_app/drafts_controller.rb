# frozen_string_literal: true

module MainApp
  module DraftsController
    extend ActiveSupport::Concern

    prepended do
      after_action :touch_session!, only: :update
    end
  end
end
