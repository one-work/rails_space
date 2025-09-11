Rails.application.routes.draw do
  namespace :space, defaults: { business: 'space' } do
    resources :grids, only: [] do
      member do
        get :qrcode
      end
    end
    resources :desks, only: [] do
      member do
        get :qrcode
      end
    end
    resources :rooms, only: [] do
      member do
        get :qrcode
      end
    end
    resources :stations do
      resources :desks do
        collection do
          post :change
        end
      end
    end
    namespace :admin, defaults: { namespace: 'admin' } do
      root 'home#index'
      resources :stations do
        resources :buildings
        resources :rooms do
          member do
            get :print_data
          end
          resources :grids do
            member do
              get :print_data
            end
          end
          resources :desks do
            member do
              get :print_data
              post :print
              post :print_all
            end
          end
        end
      end
      resources :rooms, only: [] do
        collection do
          get :all
        end
      end
      resources :desks, only: [] do
        collection do
          get :all
        end
      end
    end
    namespace :me, defaults: { namespace: 'me' } do
      resources :rooms do
        member do
          post :in
          post :out
          get :qrcode
        end
        resources :grids do
          member do
            post :in
            post :out
            get :qrcode
          end
        end
      end
    end
  end
end
