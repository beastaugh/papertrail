Config::Application.routes.draw do
  match 'books/page/:page'   => 'books#index'
  
  match 'books/covers'       => 'books#covers', :as => :books_covers
  match 'books/autofill'     => 'books#autofill', :as => :books_autofill
  
  match 'authors/page/:page' => 'authors#index'
  
  resources :books
  resources :authors
  
  match 'graphs'           => 'graphs#index'
  match 'graphs/frequency' => 'graphs#frequency'
  
  root :to => 'books#index'
end
