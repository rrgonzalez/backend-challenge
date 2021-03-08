Rails.application.routes.draw do

  resources :member, only: [:create, :index, :show] do
    member do
      post :add_friend
      get :search_closest_expert
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
