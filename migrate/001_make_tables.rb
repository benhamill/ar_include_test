class MakeTables < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
    end

    create_table :comments do |t|
      t.string :body
      t.integer :user_id
    end
  end
end
