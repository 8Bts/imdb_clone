class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.integer :rating
      t.references :user, null: false, foreign_key: {on_delete: :cascade}
      t.references :movie, null: false, foreign_key: {on_delete: :cascade}

      t.timestamps

      t.index [:user_id, :movie_id], unique: true
    end
  end
end
