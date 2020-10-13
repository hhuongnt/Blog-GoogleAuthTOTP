class User < ApplicationRecord
  before_save :valid_two_factor_confirmation
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :rates, dependent: :destroy
  has_many :rate_posts, through: :rates

  mount_uploader :avatar, AvatarUploader
  validates :first_name, :last_name, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :two_factor_authenticatable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:facebook]
  has_one_time_password(encrypted: true)

  def need_two_factor_authentication?(_request)
    two_factor_enabled? && !unconfirmed_two_factor?
  end

  def self.find_for_facebook_oauth(auth, _signed_in_resource = nil)
    user = User.where(provider: auth.provider, uid: auth.uid).or(User.where(email: auth.info.email)).first

    return user if user.present?

    user = User.new(
      name: auth.extra.raw_info.name,
      provider: auth.provider,
      uid: auth.uid,
      email: auth.info.email,
      password: Devise.friendly_token[0, 20],
      image: auth.info.image,
      first_name: auth.extra.raw_info.name.split.first,
      last_name: auth.extra.raw_info.name.split.last
    )
    user.skip_confirmation!
    user.save
    user
  end

  def admin?
    role == 'admin'
  end

  def confirm_two_factor!(code)
    update_attributes(unconfirmed_two_factor: false) if authenticate_otp(code)
  end

  private

  def valid_two_factor_confirmation
    return true unless two_factor_just_set || phone_changed_with_two_factor

    self.unconfirmed_two_factor = true
  end

  def two_factor_just_set
    two_factor_enabled? && two_factor_enabled_changed?
  end

  def phone_changed_with_two_factor
    two_factor_enabled? && phone_number_changed?
  end
end
