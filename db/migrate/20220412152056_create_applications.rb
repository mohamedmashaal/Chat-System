class CreateApplications < ActiveRecord::Migration[5.0]
  def change
    create_table :applications do |t|
      t.string :name
      t.string :token, index: {unique: true}
      t.integer :chats_count

      t.timestamps
    end
  end
end
