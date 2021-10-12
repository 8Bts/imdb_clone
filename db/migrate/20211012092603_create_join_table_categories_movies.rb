class CreateJoinTableCategoriesMovies < ActiveRecord::Migration[6.1]
  def change
    create_join_table :categories, :movies do |t|
      t.index :category_id
      t.index :movie_id
    end
  end
end
