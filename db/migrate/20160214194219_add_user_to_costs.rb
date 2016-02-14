class AddUserToCosts < ActiveRecord::Migration
  def change
    add_reference :costs, :user, index: true, foreign_key: true
  end
end
