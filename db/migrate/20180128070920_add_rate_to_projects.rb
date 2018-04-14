class AddRateToProjects < ActiveRecord::Migration[5.2]
  def change
    add_monetize :projects, :rate
  end
end
