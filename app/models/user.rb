class User
  include Mongoid::Document

  field :email, type: String
  field :encrypted_password, type: String
  field :auth_token, type: String
  attr_accessor :password
end
