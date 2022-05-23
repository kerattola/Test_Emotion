class CreateEmolevels < ActiveRecord::Migration[6.0]
  def change
    create_table :emolevels do |t|
      t.integer :scale1
      t.integer :scale2
      t.integer :scale3
      t.integer :scale4
      t.integer :scale5
      t.integer :emosum
      t.integer :time
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
