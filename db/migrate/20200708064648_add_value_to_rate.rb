class AddValueToRate < ActiveRecord::Migration[6.0]
  def change
    add_column :rates, :value, :float
  end
end
