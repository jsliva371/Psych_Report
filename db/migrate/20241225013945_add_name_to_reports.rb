class AddNameToReports < ActiveRecord::Migration[7.1]
  def change
    add_column :reports, :name, :string
  end
end
