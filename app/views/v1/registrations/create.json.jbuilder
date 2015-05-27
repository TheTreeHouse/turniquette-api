json.registration do
  if @user
    json.success true
    json.email @user.email
  else
    json.success false
  end
end
