# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

case Rails.env
when "development"
  User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             login: "example_user",
             roles: "A",
             password:              "foobar",
             password_confirmation: "foobar")

  99.times do |n|
    name  = Faker::Name.name
    login = Faker::Internet.user_name
    next if User.find_by login: login
    email = "example-#{n+1}@railstutorial.org"
    password = "password"
    User.create!(name:  name,
                 email: email,
                 login: login,
                 password:              password,
                 password_confirmation: password)
  end
  # instances
  i1=BearsInstance.create!(name:"VPC UK",comment:"VPC UK BEARS instance")
  i2=BearsInstance.create!(name:"VPC Germany",comment:"VPC Germany BEARS instance")
  
  # datacenters
  i1.data_centers.create!(name:"Wynyard",dc_code:"WYN")
  i1.data_centers.create!(name:"Doxford",dc_code:"DXS")
  i2.data_centers.create!(name:"E-Shelter",dc_code:"EDC")
  i2.data_centers.create!(name:"Russelsheim",dc_code:"DEG")
end