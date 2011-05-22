Config::Application.routes.draw do
  get "login" => "sessions#new", :as => "login"
  get "logout" => "sessions#destroy", :as => "logout"

  match 'books/page/:page'   => 'books#index'
  
  match 'books/covers'       => 'books#covers', :as => :books_covers
  match 'books/autofill'     => 'books#autofill', :as => :books_autofill
  
  match 'authors/page/:page' => 'authors#index'
  
  resources :books
  resources :authors
  resources :users
  resources :sessions
  
  match 'graphs'           => 'graphs#index'
  match 'graphs/frequency' => 'graphs#frequency'
  
  root :to => 'books#index'
end
