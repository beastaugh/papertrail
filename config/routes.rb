Papertrail::Application.routes.draw do
  match 'books/page/:page' => 'books#index'
  match 'authors/page/:page' => 'authors#index'
  match 'books/covers' => 'books#covers', :as => :books_covers
  resources :books
  resources :authors
  match 'graphs' => 'graphs#index'
  match 'graphs/frequency' => 'graphs#frequency'
  root :to => 'books#index'
end
