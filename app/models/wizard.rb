
class Wizard < ApplicationRecord
  # Validations
  password_format = /(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+/
  validates :name, :email, :password, :date_of_birth, presence: true
  validates :email, uniqueness: true
  validates :bio, length: { maximum: 300, message: "must be 300 characters or less" }, allow_blank: true
  validates :password, format: {
    with: password_format,
    message: "must include at least one uppercase letter, one lowercase letter, and one number"
  }, unless: :admin?

  enum :hogwarts_house, {
    gryffindor: "Gryffindor",
    hufflepuff: "Hufflepuff",
    slytherin: "Slytherin",
    ravenclaw: "Ravenclaw"
  }, prefix: true

  # Callbacks
  before_create :assign_hogwarts_house
  after_create_commit :send_welcome_email


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
end
