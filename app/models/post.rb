module Forumtastic
  class Post
    include DataMapper::Resource
    include Paginate::Finder
  
    property :id,                   Serial
    property :topic_id,             Integer
    property :body,                 Text
    property :user_id,              Integer
    property :created_at,           DateTime
    
    validates_present :body, :user_id, :topic_id
  
    belongs_to :user
    belongs_to :topic
    
    is :markup, :source => :body
    
    after :create, :update_forum
    after :create, :update_topic
    
    def update_topic
      topic.update_attributes(
        :post_count => Post.count(:topic_id => self.topic_id)
      )
      # :last_post_id => self.id,
      # :last_user_id => self.user_id
    end
    
    def update_forum
      topic.forum.update_attributes(
        :post_count => self.topic.forum.topics.posts.count
      )
    end
    
  end
end
