puts 'Loading Schema...'

class Schema < ActiveRecord::Migration
  def change
    create_table :libraries do |t|
		t.string :name
		t.string :tag_name
		t.string :license
		t.string :homepage
		t.string :language
		t.string :github_user
		t.string :github_repo
		t.integer :github_id
		t.boolean :not_found
		t.timestamps :null => false
    end
    create_table :extractions do |t|
		t.integer :open_issues
		t.integer :size
		t.integer :stargazers_count
		t.integer :library_id
		t.timestamps :null => false
    end
  end
end