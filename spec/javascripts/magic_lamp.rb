MagicLamp.fixture(extend: AuthStub) do
  render partial: "layouts/sidebar"
end

MagicLamp.fixture do
  render template: "users/index"
end

MagicLamp.fixture do
  render template: "admin/credentials/index"
end