class RegistrationService
  def from_invitation(email, invitation_token, user_data = {})
    invitation = Invitation.find_by(email: email, token: invitation_token)
    user = User.where(email: email).first
    user ||= User.create!({ email: email }.merge!(user_data))
    invitation.destroy
    user
  rescue Mongoid::Errors::DocumentNotFound
    # find & find_by raises exception if not found
    raise InvalidInvitationError
  end

  class InvalidInvitationError < Exception
  end
end
