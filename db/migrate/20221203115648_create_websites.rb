class CreateWebsites < ActiveRecord::Migration[7.0]
  def change
    create_table :websites do |t|
      t.string  :url, null: false, comment: '网站地址'
      t.references :user, null: false

      t.timestamps
    end
  end
end
