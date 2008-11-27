module Forumtastic
  module Router
    # Set up the many and various routes for Gluttonberg
    def self.setup(scope)
      scope.resources :forums do |forum|
        forum.resources :topics do |topic|
          topic.resources :posts
        end
        forum.resources :posts
      end
      scope.resources :users do |user|
        user.resources :posts
      end
      scope.resources :posts
      scope.match("/login", :method => :get ).to(:controller => "/exceptions", :action => "unauthenticated").name(:login)
      scope.match("/login", :method => :put ).to(:controller => "sessions", :action => "update").name(:perform_login)
      scope.match("/logout").to(:controller => "sessions", :action => "destroy").name(:logout)      
      scope.match('/').to(:controller => 'forums', :action => 'index').name(:home)
    end
  end
end