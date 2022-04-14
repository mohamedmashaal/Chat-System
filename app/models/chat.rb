class Chat < ApplicationRecord
  validates :number, uniqueness: { scope: :application_id }
  has_many :messages, dependent: :destroy
  belongs_to :application, counter_cache: true
end
