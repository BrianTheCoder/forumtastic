if defined?(Merb::Plugins)

  $:.unshift File.dirname(__FILE__)

  load_dependency 'merb-slices'
  Merb::Plugins.add_rakefiles "forumtastic/merbtasks", "forumtastic/slicetasks", "forumtastic/spectasks"

  # Register the Slice for the current host application
  Merb::Slices::register(__FILE__)
  
  # Slice configuration - set this in a before_app_loads callback.
  # By default a Slice uses its own layout, so you can swicht to 
  # the main application layout or no layout at all if needed.
  # 
  # Configuration options:
  # :layout - the layout to use; defaults to :forumtastic
  # :mirror - which path component types to use on copy operations; defaults to all
  Merb::Slices::config[:forumtastic][:layout] ||= :forumtastic
  
  # All Slice code is expected to be namespaced inside a module
  module Forumtastic
    
    # Slice metadata
    self.description = "Forumtastic is a chunky Merb slice!"
    self.version = "0.0.5"
    self.author = "Brian Smith"
    
    # Stub classes loaded hook - runs before LoadClasses BootLoader
    # right after a slice's classes have been loaded internally.
    def self.loaded
    end
    
    # Initialization hook - runs before AfterAppLoads BootLoader
    def self.init
      Merb.add_mime_type(:atom, nil, ["application/atom+xml"])
      Merb.add_mime_type(:rss, nil, ["application/rss+xml"])
    end
    
    # Activation hook - runs after AfterAppLoads BootLoader
    def self.activate
      Merb::Authentication.user_class = Forumtastic::User
      Merb::Authentication.activate!(:default_password_form)
      Merb::Plugins.config[:"merb-auth"][:login_param] = "email"
      Merb::Authentication.class_eval do 
        def store_user(user)
          return nil unless user 
          user.id
        end
        def fetch_user(session_info)
          User.get(session_info)
        end
      end
    end
    
    # Deactivation hook - triggered by Merb::Slices.deactivate(Forumtastic)
    def self.deactivate
    end
    
    # Setup routes inside the host application
    #
    # @param scope<Merb::Router::Behaviour>
    #  Routes will be added within this scope (namespace). In fact, any 
    #  router behaviour is a valid namespace, so you can attach
    #  routes at any level of your router setup.
    #
    # @note prefix your named routes with :forumtastic_
    #   to avoid potential conflicts with global named routes.
    def self.setup_router(scope)
      Forumtastic::Router.setup(scope)
    end
    
  end
  
  # Setup the slice layout for Forumtastic
  #
  # Use Forumtastic.push_path and Forumtastic.push_app_path
  # to set paths to forumtastic-level and app-level paths. Example:
  #
  # Forumtastic.push_path(:application, Forumtastic.root)
  # Forumtastic.push_app_path(:application, Merb.root / 'slices' / 'forumtastic')
  # ...
  #
  # Any component path that hasn't been set will default to Forumtastic.root
  #
  # Or just call setup_default_structure! to setup a basic Merb MVC structure.
  Forumtastic.setup_default_structure!
  
  # Add dependencies for other Forumtastic classes below. Example:
  # dependency "forumtastic/other"
  # Third party dependencies
  merb_version = "1.0.1"
  datamapper_version = "0.9.7"
  
  dependency 'merb-assets',     merb_version
  dependency 'merb-helpers',    merb_version
  dependency 'merb_datamapper', merb_version
  dependency 'dm-is-tree',      datamapper_version
  dependency 'dm-observer',     datamapper_version
  dependency 'dm-is-list',      datamapper_version
  dependency 'dm-validations',  datamapper_version
  dependency 'dm-timestamps',   datamapper_version
  dependency 'dm-types',        datamapper_version
  dependency 'dm-aggregates',   datamapper_version
  dependency 'dm-is-markup',    datamapper_version
  dependency 'merb-auth-core',  merb_version
  dependency 'merb-auth-more',  merb_version do
    require 'merb-auth-more/mixins/redirect_back'
  end
  dependency 'compass', '0.1.0'
  dependency 'RedCloth'

  require "forumtastic/router"
  require "paginate/collection"
  require "paginate/finder"
  require "paginate/collection"
  require "paginate/view_helpers"
end