module Forumtastic
  class Moderating
    include DataMapper::Resource
  
    property :id,               Serial
    property :user_id,          Integer
    property :forum_id,         Integer
    property :created_at,       DateTime
    property :updated_at,       DateTime
    
    validates_present :user_id, :forum_id
    validates_is_unique :user_id, :scope => :forum_id
    
    belongs_to :user
    belongs_to :forum, :class_name => "Forum"

  end
end