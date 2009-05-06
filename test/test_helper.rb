require 'rubygems'
require 'test/unit'
require 'active_support'
require 'active_support/test_case'

ENV['RAILS_ENV'] = 'test'
ENV['RAILS_ROOT'] ||= File.dirname(__FILE__) + '/../../../../'

require File.expand_path(File.join(ENV['RAILS_ROOT'], 'config/environment.rb'))
require File.dirname(__FILE__) + '/../init.rb'

def load_schema
  require 'mysql'
  
  config = YAML::load(IO.read(ENV['RAILS_ROOT'] + 'config/database.yml'))
  ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
  ActiveRecord::Base.establish_connection(config["mysql"])
  
  load(File.dirname(__FILE__) + "/schema.rb")
  require File.dirname(__FILE__) + '/../init.rb'
end

class TestStateMachine < ActiveRecord::Base
  include AASM
  aasm_column :state
  aasm_initial_state :pending
  aasm_state :pending
  aasm_state :active
  aasm_event :activate do
    transitions :from => :pending, :to => :active 
  end
  state_machine_history
end

class AnotherTestStateMachine < ActiveRecord::Base
  include AASM
  aasm_column :status_column
  aasm_initial_state :pending
  aasm_state :pending
  aasm_state :active
  aasm_event :activate do
    transitions :from => :pending, :to => :active 
  end
  state_machine_history :column => :status_column
end