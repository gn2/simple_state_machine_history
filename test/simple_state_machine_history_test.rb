require File.dirname(__FILE__) + '/test_helper'

class SimpleStateMachineHistoryTest < ActiveSupport::TestCase
  load_schema

  def teardown
    SimpleStateTransition.destroy_all
    TestStateMachine.destroy_all
    AnotherTestStateMachine.destroy_all
  end
  
  test "schema has loaded correctly" do
    assert_equal [], SimpleStateTransition.all
  end
  
  context "A State machine" do
    setup do
      @tsm = TestStateMachine.new
    end
    
    
    should "have many SimpleStateTransition" do
      @tsm.save
    
      assert_respond_to @tsm, :simple_state_transitions
      assert_instance_of SimpleStateTransition, @tsm.simple_state_transitions.first
    end
    
    # Testing state_machine_column
    should "have a :state_machine_column class attribute" do
      assert_respond_to TestStateMachine, :state_machine_column
    end

    should "have :state as a default state column" do
      assert_equal :state, TestStateMachine.state_machine_column
    end

    should "be able to change their state column" do
      assert_equal :status_column, AnotherTestStateMachine.state_machine_column
    end
  
    # Testing behaviour
    should "record  their default state in history" do
      @tsm.save
      transition = SimpleStateTransition.find(:first, :conditions => {:simple_state_machine_id => @tsm.id, :simple_state_machine_type => "TestStateMachine"})
    
      assert_not_nil transition
      assert_equal transition.name, 'pending'
    end

    should "record state transitions in history" do
      @tsm.save
      @tsm.activate!
      transition = SimpleStateTransition.find(:last, :conditions => {:simple_state_machine_id => @tsm.id, :simple_state_machine_type => "TestStateMachine"})
    
      assert_not_nil transition
      assert_equal transition.name, 'active'
    end
  
    # Testing instance methods  
    should "only record a transition if its state has been updated" do
      transition = SimpleStateTransition.find(:last, :conditions => {:simple_state_machine_id => @tsm.id, :simple_state_machine_type => "TestStateMachine"})
      assert_nil transition
      
      @tsm.save
      
      transition = SimpleStateTransition.find(:last, :conditions => {:simple_state_machine_id => @tsm.id, :simple_state_machine_type => "TestStateMachine"})
      assert_not_nil transition
    end
  
    should "be able to save its last transition" do
      @tsm.save
      transition = SimpleStateTransition.find(:last, :conditions => {:simple_state_machine_id => @tsm.id, :simple_state_machine_type => "TestStateMachine"})
      
      assert_equal transition.name, @tsm.state
    end
  
    should "provide its last state" do
      @tsm.save
      transition = SimpleStateTransition.find(:last, :conditions => {:simple_state_machine_id => @tsm.id, :simple_state_machine_type => "TestStateMachine"})
      
      assert_equal transition.name, @tsm.last_state
    end
  
    should "know when its state has been updated" do
      @tsm.save
      @tsm.state = "lorem_ipsum"
      
      assert @tsm.recently_changed_state?
    end
  end
end
