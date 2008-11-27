module Forumtastic
  class Forums < Forumtastic::Application
    provides :xml
    
    def index
      @forums = Forum.all
      display @forums
    end

    def show
      @forum = Forum.get(params[:id])
      @topics = @forum.topics.paginate(:page => params[:page], :order => [:updated_at.desc])
      display @forum
    end

    def new
      only_provides :html
      @forum = Forum.new
      display @user
    end

    def edit
      only_provides :html
      @forum = Forum.get(params[:id])
      raise NotFound unless @forum
      display @forum
    end

    def delete
      only_provides :html
      @forum = Forum.get(params[:id])
      raise NotFound unless @forum
      display @forum    
    end

    def create
      @forum = Forum.new(params['forumtastic::forum'])
      if @forum.save
        redirect slice_url(:forumtastic, :forum, @forum), :message => {:notice => "Forum was successfully created"}
      else
        message[:error] = "Forum failed to be created"
        render :new
      end
    end

    def update
      @forum = Forum.get(params[:id])
      raise NotFound unless @forum
      if @forum.update_attributes(params['forumtastic::forum'])
         redirect slice_url(:forumtastic, :forum, @forum)
      else
        display @forum, :edit
      end
    end

    def destroy
      @forum = Forum.get(params[:id])
      raise NotFound unless @forum
      if @forum.destroy
        redirect slice_url(:forumtastic, :forums)
      else
        raise InternalServerError
      end
    end
  
  end
end