module Forumtastic
  class Users < Forumtastic::Application

    def index
      @users = User.paginate(:page => params[:page])
      display @users
    end

    def show
      @user = User.get(params[:id])
      @posts = @user.posts.paginate(:page => params[:page])
      display @user
    end

    def new
      only_provides :html
      @user = User.new
      display @user
    end

    def edit
      only_provides :html
      @user = User.get(params[:id])
      raise NotFound unless @user
      display @user
    end

    def delete
      only_provides :html
      @user = User.get(params[:id])
      raise NotFound unless @user
      display @user    
    end

    def create
      @user = User.new(params['forumtastic::user'])
      if @user.save
        redirect slice_url(:forumtastic, :user, @user), :message => {:notice => "User was successfully created"}
      else
        message[:error] = "User failed to be created"
        render :new
      end
    end

    def update
      @user = User.get(params[:id])
      raise NotFound unless @user
      if @user.update_attributes(params['forumtastic::user'])
         redirect slice_url(:forumtastic, :user, @user)
      else
        display @user, :edit
      end
    end

    def destroy
      @user = User.get(params[:id])
      raise NotFound unless @user
      if @user.destroy
        redirect slice_url(:forumtastic, :users)
      else
        raise InternalServerError
      end
    end
  
  end
end
