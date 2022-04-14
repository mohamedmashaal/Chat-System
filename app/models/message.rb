class Message < ApplicationRecord
  belongs_to :chat, counter_cache: true
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks


  def as_indexed_json(options = {})
    self.as_json(
      only: [:id, :chat_id, :number, :body]
    )
  end

end
