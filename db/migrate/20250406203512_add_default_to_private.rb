class AddDefaultToPrivate < ActiveRecord::Migration[8.0]
  def change
    change_column_default(
      :users,
      :private,
      true
    )
  end
end
