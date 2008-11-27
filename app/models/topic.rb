module Forumtastic
  class Topic
    include DataMapper::Resource
    include Paginate::Finder
  
    property :id,                   Serial
    property :forum_id,             Integer
    property :title,                String
    property :created_at,           DateTime
    property :updated_at,           DateTime
    property :last_updated_at,      DateTime
    # property :last_post_id,         Integer
    # property :last_user_id,         Integer
    property :user_id,              Integer
    property :locked,               Boolean, :default => false
    property :sticky,               Boolean, :default => false
    property :post_count,           Integer
    
    validates_present :title, :user_id, :forum_id
  
    belongs_to :user
    belongs_to :forum, :class_name => "Forum"
    # wtf? 
    # belongs_to :last_post, :class_name => "Post", :child_key => [:last_post_id]
    # belongs_to :last_user, :class_name => "User", :child_key => [:last_user_id]
    has n, :posts
    has n, :watchings
    has n, :watchers, :through => :watchings
    
    attr_accessor :body
    
    after :create, :update_topic
    before :create, :make_initial_post
    after :destroy, :update_topic
    
    def last_post
      Post.first(:topic_id => self.id, :order => [:created_at.desc])
    end
    
    def last_user
      Post.first(:topic_id => self.id, :order => [:created_at.desc]).user
    end
    
    def watched_by?(user)
      watchers.include? user
    end
    
    def update_topic
      forum.update_attributes(:topic_count => Topic.count(:forum_id => self.forum_id))
    end    
    
    def make_initial_post
      self.posts << Post.new(:user_id => self.user_id, :body => body)
    end
    
  end
end