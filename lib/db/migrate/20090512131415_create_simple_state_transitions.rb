class CreateSimpleStateTransitions < ActiveRecord::Migration 
  def self.up 
    create_table :simple_state_transitions, :force => true do |t|
      t.string    :name,                       :null => false
      t.integer   :simple_state_machine_id,    :null => false
      t.string    :simple_state_machine_type,  :null => false
      t.datetime  :created_at
  end  
  
  def self.down 
    drop_table :simple_state_transitions  
  end 
end 