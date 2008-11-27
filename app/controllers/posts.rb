module Forumtastic
  class Posts < Forumtastic::Application
    before :find_parents
    before :find_post, :only => [:edit, :update, :destroy]
    
    provides :xml
    
    def index
      provides :atom, :rss
      @posts = (@parent ? @parent.posts : Post).all
      display @posts
    end

    def show
      display @post
    end

    def new
      only_provides :html
      @post = Post.new
      display @user
    end

    def edit
      only_provides :html
      raise NotFound unless @post
      display @post
    end

    def delete
      only_provides :html
      raise NotFound unless @post
      display @post    
    end

    def create
      @post = Post.new(params[:post].merge(:user_id => session.user.id, :topic_id => params[:topic_id]))
      if @post.save
        redirect slice_url(:forumtastic, :forum_topic, params[:forum_id], params[:topic_id]), 
          :message => {:notice => "Post was successfully created"}
      else
        message[:error] = "Post failed to be created"
        render :new
      end
    end

    def update
      raise NotFound unless @post
      if @post.update_attributes(params[:post])
         redirect slice_url(:forumtastic, :forum_topic, params[:forum_id], params[:topic_id]),
          :message => {:notice => "Post was successfully updated"}
      else
        display @post, :edit
      end
    end

    def destroy
      raise NotFound unless @post
      if @post.destroy
        redirect slice_url(:posts)
      else
        raise InternalServerError
      end
    end
  
    protected
    
      def find_parents
        if params[:user_id]
          @parent = @user = User.get(params[:user_id])
        elsif params[:forum_id]
          @parent = @forum = Forum.get(params[:forum_id])
          @parent = @topic = Topic.first(:id => params[:topic_id], :forum_id => params[:forum_id]) if params[:topic_id]
        end
      end

      def find_post
        @post = @topic.posts.get(params[:id])
      end
      
  end
end