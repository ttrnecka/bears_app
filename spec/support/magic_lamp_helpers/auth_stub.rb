module AuthStub
  def current_user
    @current_user ||= User.create!(name:  "Example User",
             email: "example2@railstutorial.org",
             login: "example_user2",
             roles: "A",
             password:              "foobar",
             password_confirmation: "foobar")
  end
end