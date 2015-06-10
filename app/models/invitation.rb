class Invitation
  include Mongoid::Document

  field :email, type: String
  field :token, type: String
  belongs_to :event

  validates_presence_of :email
  validates_uniqueness_of :email, scope: :event

  before_create :set_token
  after_create :send_mail

  private

  def set_token
    self.token = 'token-test'
  end

  def send_mail
    RegistrationMailer.invite(self).deliver_now
  end
end
