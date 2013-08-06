gem 'activerecord', '4.0.0'
require 'active_record'
require 'sqlite3'
require 'logger'
require 'minitest/autorun'

# This connection will do for database-independent bug reports.
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveRecord::Schema.define do
  create_table :users do |t|
    t.string :name
  end

  create_table :comments do |t|
    t.string :body
    t.integer :user_id
  end
end

class User < ActiveRecord::Base
  has_many :comments
end

class Comment < ActiveRecord::Base
  belongs_to :user
end

class BugTest < MiniTest::Unit::TestCase
  def test_includes_where_select
    query = User.select('random() AS ranking').order('ranking').includes(:comments)
      .where(comments: { id: 1 })

    assert_equal ['random() AS ranking'], query.select_values
    assert_equal [], query.to_a
  end
end
