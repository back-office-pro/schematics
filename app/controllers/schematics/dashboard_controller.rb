# frozen_string_literal: true

module Schematics
  class DashboardController < ApplicationController
    def home
      @charts = ::Chart
                .left_joins(:roles)
                .where(roles: [current_user.role, nil])
      @stats = ::Stat
               .left_joins(:roles)
               .where(roles: [current_user.role, nil])
    end

    def admin
      authorize! :read, :admin_dashboard
    end

    def read_notifications
      current_user.update!(updated_at: ::Time.current)
    end
  end
end
