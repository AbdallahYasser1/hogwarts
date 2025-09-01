class Wizard < ApplicationRecord
  # Active Storage for avatar
  has_one_attached :avatar
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Validations
  validates :name, :email, :date_of_birth, presence: true
  validates :email, uniqueness: true
  validates :bio, length: { maximum: 300, message: "must be 300 characters or less" }, allow_blank: true
  validate :password_complexity
  validates :avatar, content_type: {
                      in: %w[image/jpeg image/gif image/png],
                      message: "must be a valid image format"
                    },
                    size: {
                      less_than: 5.megabytes,
                      message: "should be less than 5MB"
                    }

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

  def password_complexity
    return if password.blank? || self.is_admin
    unless password =~ /(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+/
      errors.add :password, "must include at least one uppercase letter, one lowercase letter, and one number"
    end
  end
end
