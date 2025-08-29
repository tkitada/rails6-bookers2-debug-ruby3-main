class RelationshipsController < ApplicationController
  def create
    user = User.find(params[:user_id])
    current_user.relationships.create(followed_id: user.id)
    redirect_to user_path(user)
  end

  def destroy
    user = User.find(params[:user_id])
    relationship = current_user.relationships.find_by(followed_id: user.id)
    relationship.destroy
    redirect_to user_path(user)
  end
end
