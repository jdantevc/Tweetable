class CreateTweets < ActiveRecord::Migration[7.1]
  def change
    create_table :tweets do |t|
      t.text :body
      t.integer :replies_count, default: 0
      t.integer :likes_count, default: 0
      t.references :user, null: false, foreign_key: true
      t.references :replied_to, foreign_key: { to_table: :tweets }

      t.timestamps
    end
  end
end