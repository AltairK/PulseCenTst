Rails.application.routes.draw do
  match 'add' => 'pages#add_root', :via => :get, :as => :add_root
  match '/' => 'pages#create_root', :via => :post
  constraints :path => %r{[/#{Page::MATCHED_SYMBOLS}]+} do
    match '*path/add' => 'pages#add', :via => :get, :as => :add
    match '*path' => 'pages#create', :via => :post
    match '*path/edit' =>  'pages#edit', :via => :get, :as => :edit
    match '*path' => 'pages#update', :via => :put
    match '*path' => 'pages#show', :via => :get, :as => :show
  end
  root :to => 'pages#show', :via => :get
end
