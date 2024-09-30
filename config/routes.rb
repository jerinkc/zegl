Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :people, only: [:show] do
    resources :settlements, only: [:index, :new, :create]
  end
  resources :expenses, only: [:index, :new, :create]

  root to: "people#show"
  get 'dummy/:id', to: 'static#person'
end
