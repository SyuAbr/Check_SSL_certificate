class User < ApplicationRecord
  acts_as_paranoid

  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  before_validation :generate_api_token, on: :create

  ROLES = ['Сотрудник', 'Администратор'].freeze

  validates :full_name, presence: true
  validates :role, inclusion: { in: ROLES }
  validates :api_token, presence: true, uniqueness: true

  def admin?
    role == 'Администратор'
  end

  private

  def generate_api_token
    self.api_token = SecureRandom.hex(16) if api_token.blank?
  end

  def set_default_role
    self.role ||= 'Сотрудник'
  end
end
