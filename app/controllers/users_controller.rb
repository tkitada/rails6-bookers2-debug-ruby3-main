class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    @today_book = @books.created_today
    @yesterday_book = @books.created_yesterday
    @this_week_book = @books.created_this_week
    @last_week_book = @books.created_last_week

    @daily_counts = (6.day.ago.to_date..Date.today).map do |date|
      label = case date
        when Date.today then #今日
        when 1.day.ago.to_date then #1日前
        when 2.day.ago.to_date then
        when 3.day.ago.to_date then
        when 4.day.ago.to_date then
        when 5.day.ago.to_date then
        when 6.day.ago.to_date then
        end
      {
        date: label,
        count: @user.books.where(created_at: date.beginning_of_day..date.end_of_day).count
      }
    end

  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: "You have updated user successfully."
    else
      render :edit
    end
  end

  def followings
    @user = User.find(params[:id])
    @users = @user.followings
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    user = User.find(params[:id])
    unless user == current_user
      redirect_to user_path(current_user)
    end
  end
end
