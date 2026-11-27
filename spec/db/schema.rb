ActiveRecord::Schema.define(:version => 0) do
  enable_extension "citext" if ActiveRecord::Base.connection.adapter_name == "PostgreSQL"
  enable_extension "hstore" if ActiveRecord::Base.connection.adapter_name == "PostgreSQL"

  create_table :posts, :force => true do |t|
    t.string :first_name
    t.string :last_name, :null => false
    t.string :title
    t.text :summary
    t.text :body
    t.column :slug, :citext
    t.integer :views
    t.integer :category_id
    t.string :blog_id
  end

  if ActiveRecord::Base.connection.adapter_name == "PostgreSQL"
    create_table :documents, :force => true do |t|
      t.string :tags, :array => true
      t.integer :scores, :array => true
      t.hstore :properties
      t.json :settings
      t.jsonb :metadata
    end
  end

end
