class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]
    @word = params[:word]
    @search_type = params[:search_type]

    if @range == "User"
      @users = search_users(@search_type, @word)
    elsif @range == "Book"
      @books = search_books(@search_type, @word)
    end
  end

  private

  def search_users(type, word)
    case type
    when "perfect"
      User.where(name: word)
    when "forward"
      User.where("name LIKE ?", "#{word}%")
    when "backword"
      User.where("name LIKE ?", "%#{word}")
    when "partial"
      User.where("name LIKE ?", "%#{word}%")
    else
      User.none
    end
  end

  def search_books(type, word)
    case type
    when "perfect"
      Book.where(title: word)
    when "forward"
      Book.where("title LIKE ?", "#{word}%")
    when "backword"
      Book.where("title LIKE ?", "%#{word}")
    when "partial"
      Book.where("title LIKE ?", "%#{word}%")
    else
      Book.none
    end
  end
end
