require 'redmine'

# Budget requires the Rate plugin
begin
  require 'rate' unless Object.const_defined?('Rate')
rescue LoadError
  # rate_plugin is not installed
  # raise Exception.new("ERROR: The Rate plugin is not installed.  Please install the Rate plugin from https://projects.littlestreamsoftware.com/projects/redmine-rate")
end

# Patches to the Redmine core.
require 'issue_patch'
require 'issue_query_patch'
require 'time_report_patch'
ActionDispatch::Callbacks.to_prepare do
  Issue.send(:include, IssuePatch) unless Issue.included_modules.include? IssuePatch
  IssueQuery.send(:include, IssueQueryPatch) unless IssueQuery.included_modules.include? IssueQueryPatch
  Redmine::Helpers::TimeReport.send(:include, TimeReportPatch) unless Redmine::Helpers::TimeReport.included_modules.include? TimeReportPatch
end

# Hooks
require_dependency 'budget_issue_hook'
require_dependency 'budget_project_hook'

Redmine::Plugin.register :budget_plugin do
  name 'Budget'
  author 'Eric Davis'
  description 'Budget is a plugin to manage the set of deliverables for each project, automatically calculating key performance indicators.'
  url 'https://projects.littlestreamsoftware.com/projects/redmine-budget'
  author_url 'http://www.littlestreamsoftware.com'
  version '0.3.0'

  requires_redmine :version_or_higher => '2.3.0'

  settings :default => {
    'budget_nonbillable_overhead' => '',
    'budget_materials' => '',
    'budget_profit' => ''
  }, :partial => 'settings/budget_settings'


  project_module :budget_module do
    permission :view_budget, { :deliverables => [:index, :issues]}
    permission :manage_budget, { :deliverables => [:new, :edit, :create, :update, :destroy, :preview, :bulk_assign_issues]}
  end

  menu :project_menu, :budget, {:controller => "deliverables", :action => 'index'}, :caption => :budget_title, :after => :activity, :param => :id
end
