class SessionService
  def authenticate(email, password)
    user = User.find_by(email: email, encrypted_password: Digest::SHA1.hexdigest(password))
    user.generate_auth_token
    user
  rescue Mongoid::Errors::DocumentNotFound
    # find & find_by raises exception if not found
    raise AuthenticationError
  end

  def authenticate_token(email, token)
    User.find_by(email: email, auth_token: token)
  rescue Mongoid::Errors::DocumentNotFound
    # find & find_by raises exception if not found
    raise AuthenticationError
  end

  def destroy(email)
    if user = User.where(email: email).first
      user.update_attribute :auth_token, nil
      user
    end
  end

  class AuthenticationError < Exception
  end
end
