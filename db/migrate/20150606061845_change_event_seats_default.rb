class ChangeEventSeatsDefault < ActiveRecord::Migration
  def change
    change_column_default :events, :seats, 8
  end
end
