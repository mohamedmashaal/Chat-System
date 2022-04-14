Rails.application.routes.draw do
  resources :applications do
    resources :chats do
      resources :messages
    end
  end
end
