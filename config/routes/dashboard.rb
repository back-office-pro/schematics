# frozen_string_literal: true

get 'admin', to: 'dashboard#admin', as: :admin
post 'dashboard/read_notifications', as: :dashboard_read_notifications
