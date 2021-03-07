Rails.application.routes.draw do

  resources :members, only: [:create, :index, :show] do
    post :add_friend, on: :member
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
