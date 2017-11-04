class CreateGuesses < ActiveRecord::Migration[5.1]
  def change
    create_table :guesses do |t|
      t.string :sha
      t.boolean :found, default: false
      t.integer :searched_count, default: 1

      t.timestamps
    end
  end
end
