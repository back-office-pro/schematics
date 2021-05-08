get    'login',   to: 'sessions#new',     as: :login
get    'profile', to: 'sessions#edit',    as: :profile
delete 'logout',  to: 'sessions#destroy', as: :logout

resource :sessions, except: :show
