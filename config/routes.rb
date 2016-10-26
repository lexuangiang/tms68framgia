Rails.application.routes.draw do
  require "sidekiq/web"

  namespace :admin do
    mount Sidekiq::Web => "/sidekiq"
    root "static_pages#index"
    resources :courses do
      resource :user_courses, only: [:show, :update]
    end
    resources :subjects
    resources :users
    resources :course_subjects, only: [:update]
  end
  root "static_pages#index"
  devise_for :users
  resources :user_courses do
    resources :user_subjects
  end
  resources :users, only: :show
end
