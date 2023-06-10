class Book < ApplicationRecord
  
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user #ここです！もしくは下記のコード
  #has_many :week_favorites, -> { where(created_at: ((Time.current.at_end_of_day - 6.day).at_beginning_of_day)..(Time.current.at_end_of_day)) }, class_name: 'Favorite'
  has_many :post_comments, dependent: :destroy
  has_many :view_counts, dependent: :destroy
  
  #8-dで追加
  scope :latest, -> {order(created_at: :desc)}
  # scope :old, -> {order(created_at: :asc)}
  scope :star_count, -> {order(star: :desc)}
  
  validates :title, presence: true
  validates :body, presence: true, length:{maximum: 200}
  #9-dで追加
  validates :category, presence: true
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
  # 検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end
  
end
