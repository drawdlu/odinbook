class OmniauthUserService
  def initialize(auth)
    @auth = auth
  end

  def find_or_create_user
    user = User.find_by(email: @auth.info.email)

    unless user
      user = User.new(
        email: @auth.info.email,
        password: Devise.friendly_token[0, 20],
        provider: @auth.provider,
        uid: @auth.uid
      )

      user.build_profile(image: @auth.info.image)

      user.save(validate: false)
    end

    user
  end
end
