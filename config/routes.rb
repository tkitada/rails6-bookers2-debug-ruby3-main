Rails.application.routes.draw do
  #検索
  get "search" => "searches#search", as: "search"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #devise関連
  devise_for :users

  #ホーム系
  root :to =>"homes#top"
  get "home/about"=>"homes#about"

  #書籍関連
  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resources :book_comments, only: [:create, :destroy]
    resource :favorite, only: [:create, :destroy]
  end

  #ユーザー関連
  resources :users, only: [:index,:show,:edit,:update] do
    resource :relationship, only: [:create, :destroy]
    get "search" => "users#search"

    member do
      get :followings
      get :followers
    end
  end


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
