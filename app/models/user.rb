class User
  include Mongoid::Document

  field :email, type: String
  field :encrypted_password, type: String
  field :auth_token, type: String
  attr_accessor :password
  has_many :events, dependent: :nullify

  validates :email, presence: true, uniqueness: true

  before_save :encrypt_password

  def generate_auth_token
    self.auth_token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless User.where(auth_token: random_token).exists?
    end
    save
  end

  private

  def encrypt_password
    self.encrypted_password = Digest::SHA1.hexdigest(password) if password
  end
end
