
class Wizard < ApplicationRecord
  # Concerns
  has_secure_password

  # Accessors
  attr_accessor :remember_token

  # Validations
  password_format = /(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+/
  validates :name, :email, :date_of_birth, presence: true
  validates :email, uniqueness: true
  validates :bio, length: { maximum: 300, message: "must be 300 characters or less" }, allow_blank: true
  validates :password, format: {
    with: password_format,
    message: "must include at least one uppercase letter, one lowercase letter, and one number"
  }, unless: :admin?, allow_nil: true

  enum :hogwarts_house, {
    gryffindor: "Gryffindor",
    hufflepuff: "Hufflepuff",
    slytherin: "Slytherin",
    ravenclaw: "Ravenclaw"
  }, prefix: true

  # Callbacks
  before_create :assign_hogwarts_house
  after_create_commit :send_welcome_email
  before_save :downcase_email

  # Static functions
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def remember
    self.remember_token = Wizard.new_token
    update_column(:remember_digest, Wizard.digest(remember_token))
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_column(:remember_digest, nil)
  end
  # Private Functions
  private

  def assign_hogwarts_house
    self.hogwarts_house = self.class.hogwarts_houses.keys.sample
  end

  def send_welcome_email
    WizardMailer.welcome_email(self).deliver_later
  end

  def admin?
    !!self.is_admin
  end

  def downcase_email
   return unless email.present?
    self.email = email.downcase
  end
end
