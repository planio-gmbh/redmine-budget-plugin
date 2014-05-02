module RedmineBudget

  module IssuePatch
    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods)

      base.class_eval do
        unloadable # Send unloadable so it will not be unloaded in development
        belongs_to :deliverable
      end
    end

    module InstanceMethods
      # Wraps the association to get the Deliverable subject.  Needed for the
      # Query and filtering
      def deliverable_subject
        deliverable.try :subject
      end
    end
  end

end
