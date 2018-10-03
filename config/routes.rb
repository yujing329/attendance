Rails.application.routes.draw do
  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'   #7.26: ユーザー登録のルーティングにPOSTリクエストを追加(リスト8.2で削除)
  get    '/login',   to: 'sessions#new'     #8.2: リソースを追加して標準的なRESTfulアクションをgetできるようにする
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users  #7.3: Usersリソースをroutesファイルに追加
end