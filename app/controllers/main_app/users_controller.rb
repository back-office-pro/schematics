# frozen_string_literal: true

module MainApp
  module UsersController
    extend ActiveSupport::Concern

    prepended do
      skip_before_action :update_last_seen_at!, only: :update # rubocop:disable Rails/LexicallyScopedActionFilter
    end
  end
end
