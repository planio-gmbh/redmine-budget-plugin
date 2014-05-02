module RedmineBudget

  # Budget requires the Rate plugin
  def self.require_rate_plugin
    begin
      require_dependency 'rate'
    rescue LoadError
      # rate_plugin is not installed
      raise Exception.new("ERROR: The Rate plugin is not installed.  Please install the Rate plugin from https://projects.littlestreamsoftware.com/projects/redmine-rate")
    end unless Object.const_defined?('Rate')
  end

end

# Hooks
require_dependency 'redmine_budget/hooks/issue_hook'
require_dependency 'redmine_budget/hooks/project_hook'
