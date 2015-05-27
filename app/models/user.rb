class User
  include Mongoid::Document

  field :email, type: String, default: ''
  field :encrypted_password, type: String, default: ''
  field :auth_token, type: String, default: ''
  attr_accessor :password
end
