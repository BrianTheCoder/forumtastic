module Forumtastic
  class Forum
    include DataMapper::Resource
    include Paginate::Finder
  
    property :id,                   Serial
    property :title,                String
    property :updated_at,           DateTime
    property :description,          Text
    property :post_count,           Integer
    property :topic_count,          Integer
    
    validates_present :title, :description
    
    has n, :topics
    has n, :moderatings
    has n, :moderators, :through => :moderatings
    
    is :list
    is :markup, :source => :description
          
    def latest_post
      latest_topic.last_post
    end
    
    def latest_topic
      Forumtastic::Topic.first(:forum_id => id, :order => [:created_at.desc])
    end
    
    def moderated_by?(user)
      moderators.include? user
    end
    
    
  end
end