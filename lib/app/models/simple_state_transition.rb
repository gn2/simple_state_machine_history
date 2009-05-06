class SimpleStateTransition < ActiveRecord::Base
  belongs_to :simple_state_machine, :polymorphic => true
end