class AddOutlierToResponses < ActiveRecord::Migration
  def change
    add_column :responses, :outlier, :boolean
  end
end
