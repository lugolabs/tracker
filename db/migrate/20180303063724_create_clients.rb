class CreateClients < ActiveRecord::Migration[5.2]
  def change
    create_table :clients, id: :uuid do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.string :name
      t.text :notes

      t.timestamps
    end

    add_column :projects, :client_id, :uuid
  end
end
