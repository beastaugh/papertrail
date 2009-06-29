ActionController::Routing::Routes.draw do |map|
  def map.controller_actions(controller, actions)
    actions.each do |action|
      self.send("#{controller}_#{action}", "#{controller}/#{action}",
        :controller => controller, :action => action)
    end
  end
  
  map.controller_actions 'books', %w[all covers]
  map.resources :books, :authors
  
  map.connect "graphs", :controller => "graphs", :action => "index"
  map.connect "graphs/frequency", :controller => "graphs", :action => "frequency"
  
  map.root :controller => 'books'
end
