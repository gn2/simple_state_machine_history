require File.dirname(__FILE__) + '/test_helper.rb'

class SimpleStateTransitionTest < Test::Unit::TestCase

  should_belong_to :simple_state_machine
  
  context "A Simple state transition" do
    should "be an instanciable Class" do
      assert_kind_of SimpleStateTransition, SimpleStateTransition.new
    end
  end

end 