module RegistrationSetup
  def setup
    @event = Event.create(name: "Moe's bar", date: Time.zone.now)
    @invitation = Invitation.create(event: @event, email: 'johndoe@example.com')
    @user_data = { email: @invitation.email, password: 'my-password' }
  end

  def teardown
    Event.delete_all
    Invitation.delete_all
    User.delete_all
  end
end
