class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :youtube_accounts, dependent: :destroy

  def full_name
    t = !first_name.empty? && !last_name.empty?
    if t
      "#{first_name.capitalize} #{last_name.capitalize}"
    elsif !first_name.empty?
      first_name.capitalize
    else
      email
    end
  end
end
