# Card model
class Card < ActiveRecord::Base
  include Translationable

  belongs_to :user
  belongs_to :block
  validates :user_id, presence: true
  before_validation :set_review_date_as_now, on: :create
  validate :texts_are_not_equal
  validates :original_text, :translated_text, :review_date,
            presence: { message: 'Необходимо заполнить поле.' }
  validates :user_id, presence: { message: 'Ошибка ассоциации.' }
  validates :block_id,
            presence: { message: 'Выберите колоду из выпадающего списка.' }
  validates :interval, :repeat, :efactor, :quality, :attempt, presence: true

  mount_uploader :image, CardImageUploader

  scope :pending, -> {
    where("review_date <= ?",
    Time.zone.now).order('RANDOM()')
  }
  scope :repeating, -> { where("quality < ?", 4).order('RANDOM()') }
  scope :with_emails, -> { where.not(email: nil) }

  def self.pending_cards_notification
    User.with_emails.each do |user|
      next unless user.cards.pending.any?
      CardsMailer.pending_cards_notification(user.email).deliver
    end
  end

  protected

  def set_review_date_as_now
    self.review_date = Time.zone.now
  end

  def texts_are_not_equal
    if full_downcase(original_text) == full_downcase(translated_text)
      errors.add(:original_text, 'Вводимые значения должны отличаться.')
    end
  end

  def full_downcase(str)
    str.mb_chars.downcase.to_s.squeeze(' ').lstrip
  end
end
