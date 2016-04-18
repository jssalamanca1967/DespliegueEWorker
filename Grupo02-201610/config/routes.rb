Rails.application.routes.draw do

  root 'pages#home'
  # Paginas Estaticas
  get 'about' => 'pages#about', as: :about

  # Paginas Dinamicas
  # => Empresa
  #resources :empresas
  get '/empresas' => 'empresa#index'
  post 'empresas' => 'empresa#create'
  get '/empresas/:nombre_empresa' => 'empresa#show', as: :empresa
  get '/empresas/:nombre_empresa/edit' => 'empresa#edit', as: :edit_empresa
  patch '/empresas/:nombre_empresa' => 'empresa#update'

  get 'signup'  => 'empresa#new'

  # => Proyecto
  get '/proyectos' => 'proyecto#index'
  get '/proyectos/:id' => 'proyecto#show', as: :proyecto
  get '/empresas/:nombre_empresa/:id' => 'proyecto#show'
  get '/proyectos/:id/edit' => 'proyecto#edit', as: :edit_proyecto
  get '/empresas/:nombre_empresa/:id/edit' => 'proyecto#edit'
  patch '/proyectos/:id' => 'proyecto#update'
  get '/empresas/:nombre_empresa/proyectos/new' => 'proyecto#new'
  post '/proyectos' => 'proyecto#create'
  get '/empresas/:nombre_empresa/:id/delete' => 'proyecto#destroy'

  # => Disenio
  get '/disenios' => 'disenio#index'
  get '/disenios/:id' => 'disenio#show', as: :disenio
  get '/empresas/:nombre_empresa/:id_proyecto/:id_disenio' => 'disenio#show'
  get '/disenios/:id/edit' => 'disenio#edit', as: :edit_disenio
  get '/empresas/:nombre_empresa/:id_proyecto/:id_disenio/edit' => 'disenio#edit'
  patch '/disenios/:id' => 'disenio#update'
  get '/empresas/:nombre_empresa/:id_proyecto/disenios/new' => 'disenio#new'
  post '/disenios' => 'disenio#create'
  get '/empresas/:nombre_empresa/:id_proyecto/:id_disenio/destroy' => 'disenio#destroy'

  # => Sesiones
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
