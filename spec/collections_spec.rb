RSpec.describe NilifyBlanks do
  context "Model with nilify_blanks collections: true on string columns" do
    before(:all) do
      class PostWithCollections < ActiveRecord::Base
        self.table_name = "posts"
        nilify_blanks collections: true
      end

      PostWithCollections.new
    end

    it "should still select the default string, text, citext columns" do
      expect(PostWithCollections.nilify_blanks_columns).to eq(['first_name', 'title', 'summary', 'body', 'slug', 'blog_id'])
    end

    it "should still convert blank strings to nils" do
      post = PostWithCollections.new(first_name: '', title: ' ', last_name: '')
      post.valid?

      expect(post.first_name).to be_nil
      expect(post.title).to be_nil
      expect(post.last_name).to eq('')
    end
  end

  context "Postgres collection columns", if: ActiveRecord::Base.connection.adapter_name == "PostgreSQL" do
    before(:all) do
      class Document < ActiveRecord::Base
        nilify_blanks
      end

      class DocumentWithCollections < ActiveRecord::Base
        self.table_name = "documents"
        nilify_blanks collections: true
      end

      Document.new
      DocumentWithCollections.new
    end

    it "should not select hstore, json and jsonb columns by default" do
      expect(Document.nilify_blanks_columns).to eq(['tags'])
    end

    it "should select hstore, json and jsonb columns with collections: true" do
      expect(DocumentWithCollections.nilify_blanks_columns).to eq(['tags', 'scores', 'properties', 'settings', 'metadata'])
    end

    it "should leave empty collections alone by default" do
      document = Document.new(tags: [], properties: {}, settings: {}, metadata: [])
      document.valid?

      expect(document.tags).to eq([])
    end

    it "should leave empty collections alone when only is given without collections" do
      klass = Class.new(ActiveRecord::Base) do
        self.table_name = "documents"
        nilify_blanks only: [:properties, :metadata]
      end
      document = klass.new(properties: {}, metadata: [])
      document.valid?

      expect(document.properties).to eq({})
      expect(document.metadata).to eq([])
    end

    it "should convert empty collections to nils with collections: true" do
      document = DocumentWithCollections.new(tags: [], properties: {}, settings: {}, metadata: [])
      document.valid?

      expect(document.tags).to be_nil
      expect(document.properties).to be_nil
      expect(document.settings).to be_nil
      expect(document.metadata).to be_nil
    end

    it "should convert empty hashes in json and jsonb columns" do
      document = DocumentWithCollections.new(settings: {}, metadata: {})
      document.valid?

      expect(document.settings).to be_nil
      expect(document.metadata).to be_nil
    end

    it "should persist nil for empty collections" do
      document = DocumentWithCollections.create!(tags: [], properties: {}, metadata: {})

      expect(document.reload.attributes.values_at('tags', 'properties', 'metadata')).to eq([nil, nil, nil])
    end

    it "should leave non-empty collections untouched, including blank elements" do
      document = DocumentWithCollections.new(
        tags: ['', 'a', nil],
        properties: { 'a' => '', 'b' => nil },
        settings: { 'a' => [] },
        metadata: [false, '', {}]
      )
      document.valid?

      expect(document.tags).to eq(['', 'a', nil])
      expect(document.properties).to eq({ 'a' => '', 'b' => nil })
      expect(document.settings).to eq({ 'a' => [] })
      expect(document.metadata).to eq([false, '', {}])
    end

    it "should leave non-empty collections untouched in the default configuration" do
      document = Document.new(tags: ['', 'a'])
      document.valid?

      expect(document.tags).to eq(['', 'a'])
    end

    it "should convert empty integer arrays with collections: true" do
      document = DocumentWithCollections.new(scores: [])
      document.valid?

      expect(document.scores).to be_nil
    end

    it "should not select integer arrays by default" do
      expect(Document.nilify_blanks_columns).to_not include('scores')
    end

    it "should not select array columns outside an explicit types list" do
      klass = Class.new(ActiveRecord::Base) do
        self.table_name = "documents"
        nilify_blanks types: [:text], collections: true
      end
      klass.new

      expect(klass.nilify_blanks_columns).to eq([])
    end

    it "should convert empty collections in columns chosen with only" do
      klass = Class.new(ActiveRecord::Base) do
        self.table_name = "documents"
        nilify_blanks only: [:scores], collections: true
      end
      document = klass.new(scores: [])
      document.valid?

      expect(document.scores).to be_nil
    end
  end
end
