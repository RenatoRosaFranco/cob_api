# frozen_string_literal: true

Rails.application.routes.draw do

  # API
  namespace :api do
    namespace :v1 do
      defaults format: :json do
        resources :athletes, only: %i[index show create update destroy]
        resources :competitions, only: %i[index show create update destroy] do

          scope module: 'competitions' do
            resources :competition_athletes, only: %i[index show create update destroy]
            resources :results, only: %i[index show create update destroy]
            resources :rankings, only: %i[index]
          end
        end
      end
    end
  end
end
