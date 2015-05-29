json.session do
  if @user
    json.success true
    json.email @user.email
    json.auth_token @user.auth_token
  else
    json.success false
  end
end
