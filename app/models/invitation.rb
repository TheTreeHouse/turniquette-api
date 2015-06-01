class Invitation
  include Mongoid::Document

  field :email, type: String
  field :token, type: String

  before_create :set_token

  private

  def set_token
    self.token = 'token-test'
  end
end
