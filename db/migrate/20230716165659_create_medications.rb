class CreateMedications < ActiveRecord::Migration[7.0]
  def change
    create_table :medications do |t|
      t.string :name
      t.float :weight
      t.string :code
      t.string :image_url
      t.belongs_to :drone, index: true, foreign_key: true
      t.timestamps
    end
  end
end
