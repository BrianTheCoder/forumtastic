module Forumtastic
  class Topics < Forumtastic::Application
    before :find_forum
    before :find_topic, :exclude => [:new, :create]
    before :ensure_authenticated, :exclude => [:index, :show]
    
    provides :xml

    def index
      redirect slice_url(:forumtastic, :forum, @forum)
    end

    def show
      @posts = @topic.posts.paginate(:page => params[:page], :order => [:created_at.asc])
      display @topic
    end

    def new
      only_provides :html
      @topic = Topic.new
      display @user
    end

    def edit
      only_provides :html
      raise NotFound unless @topic
      display @topic
    end

    def delete
      only_provides :html
      raise NotFound unless @topic
      display @topic    
    end

    def create
      @topic = Topic.new(params[:topic].merge(:user => session.user, :forum_id => params[:forum_id]))
      if @topic.save
        redirect slice_url(:forumtastic, :forum_topic, params[:forum_id], @topic), 
          :message => {:notice => "Topic was successfully created"}
      else
        message[:error] = "Topic failed to be created"
        render :new
      end
    end

    def update
      raise NotFound unless @topic
      if @topic.update_attributes(params[:topic])
        redirect slice_url(:forumtastic, :forum_topic, params[:forum_id], @topic),
          :message => {:notice => "Topic was successfully updated"}
      else
        display @topic, :edit
      end
    end

    def destroy
      raise NotFound unless @topic
      if @topic.destroy
        redirect slice_url(:forumtastic, :topics)
      else
        raise InternalServerError
      end
    end
  
    protected
      def find_forum
        @forum = Forum.get(params[:forum_id])
      end
      
      def find_topic
        @topic = Topic.first(:id => params[:id], :forum_id => params[:forum_id])
      end
  end
end
