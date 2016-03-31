class AddBrowser < ActiveRecord::Migration
  def change
    add_column :sessions, :browser, :string
  end
end
