class Application < ApplicationRecord
  has_many :chats, dependent: :destroy
  has_secure_token
end
