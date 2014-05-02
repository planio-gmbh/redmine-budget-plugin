require_dependency 'redmine_budget'

Redmine::Plugin.register :redmine_budget do
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

Rails.configuration.to_prepare do
  RedmineBudget::require_rate_plugin unless defined?(Rate)
  Issue.send(:include, RedmineBudget::IssuePatch) unless Issue.included_modules.include? RedmineBudget::IssuePatch
  IssueQuery.send(:include, RedmineBudget::IssueQueryPatch) unless IssueQuery.included_modules.include? RedmineBudget::IssueQueryPatch
  Redmine::Helpers::TimeReport.send(:include, RedmineBudget::TimeReportPatch) unless Redmine::Helpers::TimeReport.included_modules.include? RedmineBudget::TimeReportPatch
end

