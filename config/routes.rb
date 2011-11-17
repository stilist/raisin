Raisin3::Application.routes.draw do
	resources :entries, :keywords do
		get "page/:page", :action => :index, :on => :collection
	end

	root :to => "entries#index"
end
