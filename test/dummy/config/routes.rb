# frozen_string_literal: true

Rails.application.routes.draw do
  get 'layoutings/composition'
  get 'layoutings/inheritance'
  get 'legacy_layoutings', to: 'legacy_layoutings#index'

  root to: 'home#index'
end
