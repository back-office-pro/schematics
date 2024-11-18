# frozen_string_literal: true

get 'logout', to: 'dashboard#logout', as: :logout
post 'dashboard/read_notifications', as: :dashboard_read_notifications
