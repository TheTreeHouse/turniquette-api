class Invitation
  include Mongoid::Document

  field :email, type: String, default: ''
  field :token, type: String, default: ''

  before_create :set_token

  private

  def set_token
    self.token = 'token-test'
  end
end
