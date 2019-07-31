class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :youtube_accounts, dependent: :destroy

  def full_name
    if first_name && last_name
      "#{first_name.capitalize} #{last_name.capitalize}"
    elsif first_name
      first_name.capitalize
    else
      email
    end
  end
end
