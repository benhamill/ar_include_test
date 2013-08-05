require 'active_record'
require './fixtures.rb'

ActiveRecord::Base.logger = Logger.new(STDOUT)

include Pry::Helpers::BaseHelpers

Pry.output.puts(
  '',
  heading('Here are the classes involved:'),
  colorize_code(File.read('./fixtures.rb')),
  '',
  'Now follow along with me:',
  ''
)

Pry.output.puts colorize_code("q1 = User.select('random() AS ranking').order('ranking').includes(:comments)"), ''
q1 = User.select('random() AS ranking').order('ranking').includes(:comments)

Pry.output.puts colorize_code('q1.to_sql'), ''

Pry.output.puts q1.to_sql, ''

Pry.output.puts colorize_code('q1.to_a'), ''
q1.to_a

Pry.output.puts '', colorize_code('q2 = q1.where(comments: { id: 1 })'), ''
q2 = q1.where(comments: { id: 1 })

Pry.output.puts colorize_code('q2.to_sql'), ''

Pry.output.puts q2.to_sql, ''

Pry.output.puts 'Now, try to do q2.to_a and watch it explode because ranking got lost. The first query (q1) is also in scope, if you want to play around.', ''
