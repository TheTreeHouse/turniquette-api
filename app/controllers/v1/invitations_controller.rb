class V1::InvitationsController < ApplicationController
  def create
    @event = Event.find(params[:event])
    emails = params[:email_list]
    @invitations = emails.map { |email| Invitation.create!(event: @event, email: email) }
  rescue Mongoid::Errors::DocumentNotFound
    render 'shared/404', status: :not_found
  end
end
