class AddDisabledAtToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :disabled_at, :datetime
  end
end
