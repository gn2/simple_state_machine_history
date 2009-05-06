%w{ models }.each do |dir|
  path = File.join(File.dirname(__FILE__), 'app', dir)
  if File.exists?(path)
    $LOAD_PATH << path
    ActiveSupport::Dependencies.load_paths << path
    ActiveSupport::Dependencies.load_once_paths.delete(path)
  end
end

module SimpleStateMachineHistory
  def self.included(base)
    base.send(:extend, ClassMethods)
  end

  module ClassMethods    
    def state_machine_history(options = {})
      # Do not allow multiple calls
      # return if self.included_modules.include?(SimpleStateMachineHistory)
      
      cattr_accessor :state_machine_column
      self.state_machine_column = (options[:column] || :state).to_sym
      
      send(:has_many, :simple_state_transitions, :as => :simple_state_machine, :dependent => :destroy)
      send(:after_save, :state_machine_updated)
      
      send(:include, InstanceMethods)
    end
  end

  module InstanceMethods
    def state_machine_updated
      record_state_transition! if recently_changed_state?
    end
    
    def record_state_transition!
      self.simple_state_transitions << SimpleStateTransition.new( :name => self.send(self.class.state_machine_column) )
    end
    
    def last_state
      last_transition = self.simple_state_transitions.last
      (last_transition.nil?) ? nil : last_transition.name
    end
    
    def recently_changed_state?
      self.send(self.class.state_machine_column) != last_state
    end
  end
end