ActionController::Routing::Routes.draw do |map|
	map.root :controller => :entries, :action => :index

	map.resources :entries
	map.resources :keywords
end
