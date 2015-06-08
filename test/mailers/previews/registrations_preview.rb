# Preview all emails at http://localhost:3000/rails/mailers/registration
class RegistrationPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/registration/invite
  def invite
    invitation = Invitation.first || Invitation.new(event: Event.first || Event.new(name: 'Treehouse'))
    RegistrationMailer.invite invitation
  end
end
