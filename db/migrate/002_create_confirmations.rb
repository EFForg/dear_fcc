class CreateConfirmations < ActiveRecord::Migration
  def self.up
    create_table :confirmations do |t|
      t.string :fcc_confirm_id, null: false
      t.datetime :fcc_received, null: false
    end
  end

  def self.down
    remove_table :confirmations
  end
end
