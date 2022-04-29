# frozen_string_literal: true

get 'admin', to: 'dashboard#admin', as: :admin
get 'logout', to: 'dashboard#logout', as: :logout
post 'dashboard/read_notifications', as: :dashboard_read_notifications
