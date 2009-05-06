require "simple_state_machine_history"

ActiveRecord::Base.send(:include, SimpleStateMachineHistory)