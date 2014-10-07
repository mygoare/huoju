class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
    	t.string			:title
    	t.text				:content
    	t.string			:category
    	t.string			:cover_image
    	t.boolean			:is_valid
    	t.integer			:favor
    	t.string			:address

      t.belongs_to  :user, index: true

      t.timestamps
    end
  end
end
