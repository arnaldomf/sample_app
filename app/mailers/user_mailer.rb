
class UserMailer < ActionMailer::Base
  add_template_helper(UsersHelper)
  default from: DefaultFrom::DEFAULT_MAIL

  def welcome_email(user, confirmation)
    @user = user
    @confirmation = confirmation
    # @url  = 'http://example.com/login'
    @url = user_confirmation_url(@user, @confirmation, host: "127.0.0.1:3000")
    mail(to: @user.email, subject: 'Welcome to my Awesome site',
      address: DefaultFrom::DEFAULT_SMTP)
  end

  def followed_email(followed, following)
    @user_followed  = followed
    @user_following = following
    @url  = url_for(controller: 'users', action: 'show', id: @user_following.id,
      host: "127.0.0.1:3000")
    mail(to: @user_followed.email, subject: "Hello #{@user_following.screen_name}"\
      " is following you!", address: DefaultFrom::DEFAULT_SMTP)
  end
end
