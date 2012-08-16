ActionController::Routing::Routes.draw do |map|
  map.connect ':id/deliverables/:action', :controller => 'deliverables'
end
