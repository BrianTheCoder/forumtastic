require 'merb-auth-more/mixins/salted_user'

module Forumtastic
  class User
    include DataMapper::Resource
    include Merb::Authentication::Mixins::SaltedUser
    include Paginate::Finder
    
    property :id,               Serial
    property :name,             String, :length => 1..100
    property :email,            String, :length => 1..100
    property :bio,              Text
    property :website,          String
    property :created_at,       DateTime
    property :updated_at,       DateTime
    property :last_active,      DateTime
    property :post_count,       Integer
    property :admin,            Boolean, :default => false
    
    validates_present :name, :email
    validates_is_unique :email, :name
    
    has n, :posts
    has n, :moderatings
    has n, :moderated_forums, :through => :moderatings
    has n, :watchings
    has n, :watched_topics, :through => :watchings
    
    is :markup, :source => :bio
    
    def moderating?(forum)
      moderated_forums.include? forum
    end
    
    def watching?(topic)
      watched_topics.include? topic
    end
    
  end
end
