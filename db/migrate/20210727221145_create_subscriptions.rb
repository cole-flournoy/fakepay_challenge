class CreateSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :subscriptions do |t|
      t.belongs_to :customer, null: false, foreign_key: true
      t.string :plan
      t.string :addr_one
      t.string :addr_two
      t.string :city
      t.string :state
      t.string :zip

      t.timestamps
    end
  end
end
