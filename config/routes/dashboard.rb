# frozen_string_literal: true

get 'admin', to: 'dashboard#admin', as: :admin

scope '/dashboard' do
  get  'chart/:id',         to: 'dashboard#chart',  as: :dashboard_chart
  post :read_notifications, controller: :dashboard, as: :dashboard_read_notifications
end
