class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects, id: :uuid do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.string :name
      t.string :color

      t.timestamps
    end
  end
end
