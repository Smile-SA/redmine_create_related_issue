ActionController::Routing::Routes.draw do |map|
  map.connect 'issues/new_related', :controller => 'issues', :action => 'new_related', :conditions => {:method => :post}
  map.connect 'projects/:project_id/issues/create_related', :controller => 'issues', :action => 'create_related', :conditions => {:method => :post}
end
