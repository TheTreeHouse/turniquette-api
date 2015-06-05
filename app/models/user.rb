class User
  include Mongoid::Document
  before_save :encrypt_password

  field :email, type: String
  field :encrypted_password, type: String
  field :auth_token, type: String
  attr_accessor :password

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
