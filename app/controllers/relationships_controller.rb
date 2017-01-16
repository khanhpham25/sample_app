class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :find_user, only: :index

  def index
    relationship = params[:type]
    @title = relationship.capitalize
    @users = @user.send(relationship).paginate page: params[:page]
  end

  def create
    @user = User.find_by id: params[:followed_id]
    if @user
      current_user.follow @user
      @relationship = current_user.active_relationships
        .find_by followed_id: @user.id
      respond_to do |format|
        format.html {redirect_to @user}
        format.js
      end
    else
      flash[:warning] = "Couldn't find this user. Please try again!"
      redirect_to root_path
    end
  end

  def destroy
    @user = Relationship.find_by(id: params[:id]).followed
    if @user
      current_user.unfollow @user
      @relationship = current_user.active_relationships.build
      respond_to do |format|
        format.html {redirect_to @user}
        format.js
      end
    else
      flash[:warning] = "Couldn't find this user. Please try again!"
      redirect_to root_path
    end
  end

  private
  def find_user
    @user = User.find_by id: params[:user_id]
    unless @user
      flash[:warning] = "Couldn't find this user. Please try again!"
      redirect_to root_path
    end
  end
end
