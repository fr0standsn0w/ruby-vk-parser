require 'sqlite3'
require 'pry'

class Database
  attr_reader :db

  def initialize
    @db = SQLite3::Database.open('./data/data.db')
    @db.results_as_hash = true
    @db.execute('CREATE TABLE IF NOT EXISTS posts(group_id INTEGER, slug TEXT)')
    @db.execute('CREATE TABLE IF NOT EXISTS post_comments(group_id INTEGER,
                 post_id INTEGER, slug TEXT)')
    @db.execute('CREATE TABLE IF NOT EXISTS topic_comments(group_id INTEGER,
                 topic_id INTEGER, slug TEXT)')
  end

  def in_db?(type, slug)
    @db.execute("SELECT * FROM #{type} WHERE slug = '#{slug}'").any?
  end

  def write_to_db(type, params = {})
    @db.execute("INSERT INTO #{type} (#{params.keys.join(', ')})" \
                "VALUES (#{('?, ' * params.size)[0...-2]})", params.values.to_a)
  end

  def close
    @db.close
  end


end