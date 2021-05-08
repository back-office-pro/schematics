scope '/dashboard' do
  get  'chart/:id',         to: 'dashboard#chart', as: :dashboard_chart
  post :read_notifications, controller: :dashboard
  post :toggle_sidebar,     controller: :dashboard
  post :toggle_theme,       controller: :dashboard
end

root 'dashboard#home'
