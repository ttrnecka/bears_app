MagicLamp.fixture(extend: AuthStub) do
  render partial: "layouts/sidebar"
end

MagicLamp.fixture do
  @users = User.all
  render template: "users/index"
end