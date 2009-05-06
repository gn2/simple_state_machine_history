ActiveRecord::Schema.define :version => 0 do
  create_table :test_state_machines, :force => true do |t|
    t.string    :state,               :null => false
  end

  create_table :another_test_state_machines, :force => true do |t|
    t.string    :status_column,       :null => false
  end

  create_table :simple_state_transitions, :force => true do |t|
    t.string    :name,                       :null => false
    t.integer   :simple_state_machine_id,    :null => false
    t.string    :simple_state_machine_type,  :null => false
    t.datetime  :created_at
  end
end