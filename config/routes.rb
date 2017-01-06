Rails.application.routes.draw do
  namespace :v1 do
    resources :pages, only: [:index] do
      collection do
        post :enqueue
      end
    end
  end
end
