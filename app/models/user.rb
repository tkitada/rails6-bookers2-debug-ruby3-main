class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :followed
  has_many :reverse_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }

  
  
  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  def following?(user)
    followings.exists?(id: user.id)
  end

  def today_book_count
    books.where(created_at: Time.zone.today.all_day).count
  end

  def yesterday_book_count
    books.where(created_at: 1.day.ago.to_date.all_day).count
  end

  def previous_day_ratio
    y = yesterday_book_count
    return "N/A" if y.zero?
    ratio = (today_book_count.to_f / y * 100).round
    "#{ratio}%"
  end

  def this_week_book_count
    end_of_week = Time.zone.today.end_of_week(:friday)
    start_of_week = end_of_week - 6.days
    books.where(created_at: start_of_week.beginning_of_day..end_of_week.end_of_day).count
  end

  def last_week_book_count
    end_of_last_week = Time.zone.today.end_of_week(:friday) - 7.days
    start_of_last_week = end_of_last_week - 6.days
    books.where(created_at: start_of_last_week.beginning_of_day..end_of_last_week.end_of_day).count
  end

  def previous_week_ratio
    last = last_week_book_count
    return "N/A" if last.zero?
    ratio = (this_week_book_count.to_f / last * 100).round
    "#{ratio}%"
  end

end
