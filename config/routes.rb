scope 'projects/:id' do
  match 'deliverables/index', :to => "deliverables#index"
  match 'deliverables/preview', :to => "deliverables#preview", :as => :preview_deliverable
  match 'deliverables', :to => "deliverables#create", :via => "post", :as => :create_deliverable
  match 'deliverables/:deliverable_id/edit', :to => "deliverables#edit", :via => "get", :as => :edit_deliverable
  match 'deliverables/:deliverable_id', :to => "deliverables#update", :via => "put", :as => :update_deliverable
  match 'deliverables/:deliverable_id/bulk_assign_issues', :to => "deliverables#bulk_assign_issues", :via => "post", :as => :bulk_assign_issues_deliverable
  match 'deliverables/:deliverable_id/issues', :to => "deliverables#issues", :as => :issues_deliverable
  match 'deliverables/:deliverable_id', :to => "deliverables#destroy", :via => "delete", :as => :destroy_deliverable
end
