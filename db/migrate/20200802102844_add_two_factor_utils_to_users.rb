class AddTwoFactorUtilsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :two_factor_enabled, :boolean, default: false
    add_column :users, :unconfirmed_two_factor, :boolean, default: true
    add_column :users, :phone_number, :string
  end
end
