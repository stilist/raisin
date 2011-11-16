Raisin3::Application.routes.draw do
	match "/" => "entries#index"
	resources :entries
	resources :keywords
end
