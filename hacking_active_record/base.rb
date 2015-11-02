require 'active_record'
require 'awesome_print'
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

def pause
  gets
end

def pause_and_clear
  gets
  system('clear')
end

system('clear')
