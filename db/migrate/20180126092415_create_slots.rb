class CreateSlots < ActiveRecord::Migration[5.2]
  def change
    create_table :slots, id: :uuid do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.references :task, type: :uuid, null: false, foreign_key: true
      t.integer :start_at
      t.integer :end_at

      t.timestamps
    end
  end
end
