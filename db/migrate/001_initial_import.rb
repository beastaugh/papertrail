class InitialImport < ActiveRecord::Migration
  def self.up
    create_table "authors" do |t|
      t.column "name",      :string
      t.column "permalink", :string
      t.column "note",      :text
    end

    create_table "books" do |t|
      t.column "title",      :string
      t.column "permalink",  :string
      t.column "author_id",  :integer
      t.column "date_added", :datetime
      t.column "comment",    :text
      t.column "cover_url",  :string
      t.column "isbn",       :string
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end
