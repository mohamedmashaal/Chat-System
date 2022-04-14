class CreateChats < ActiveRecord::Migration[5.0]
  def change
    create_table :chats do |t|
      t.belongs_to :application
      t.integer :number
      t.integer :messages_count

      t.timestamps
    end
  end
end
