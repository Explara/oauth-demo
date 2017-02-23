Rails.application.routes.draw do
  get '/' => 'rest#login'
  get 'verifyLogin' => 'rest#verifyLogin'
  get 'events' => 'rest#eventlist'
  get 'attendeelist' => 'rest#attendeelist'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
