class RegistrationMailer < ApplicationMailer
  def invite(invitation)
    @event = invitation.event

    subject = "You've got an invitation from '#{ @event.name }''"
    mail to: invitation.email, subject: subject
  end
end
