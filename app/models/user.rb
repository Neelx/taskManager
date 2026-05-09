class User < ApplicationRecord
  has_secure_password

  has_many :tasks, dependent: :destroy

  validates :name,  presence: true, length: { minimum: 2, maximum: 50 }
  validates :email, presence: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP },
                    uniqueness: { case_sensitive: false }

  before_save { self.email = email.downcase }

  def initials
    name.split.map(&:first).join.upcase.first(2)
  end
end
