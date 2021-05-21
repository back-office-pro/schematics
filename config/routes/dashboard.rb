scope '/dashboard' do
  get  'chart/:id',         to: 'dashboard#chart', as: :dashboard_chart
  post :read_notifications, controller: :dashboard
end

root 'dashboard#home'
