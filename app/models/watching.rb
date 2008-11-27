module Forumtastic
  class Watching
    include DataMapper::Resource
  
    property :id,               Serial
    property :user_id,          Integer
    property :topic_id,         Integer
    property :created_at,       DateTime
    property :updated_at,       DateTime
    property :active,           Boolean, :default => true
    
    belongs_to :topic
    belongs_to :user
    
    validates_present :user_id, :topic_id
    validates_is_unique :user_id, :scope => :topic_id
  end
end