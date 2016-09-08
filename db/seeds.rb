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
  i3=BearsInstance.create!(name:"VPC Japan",comment:"VPC Japan BEARS instance")
  i4=BearsInstance.create!(name:"VPC Netherland/Belgium",comment:"VPC Netherland/Belgium BEARS instance")
  i5=BearsInstance.create!(name:"VPC Tulsa",comment:"VPC Tulsa BEARS instance")
  
  # datacenters
  dc1=i1.data_centers.create!(name:"Wynyard",dc_code:"WYN")
  dc2=i1.data_centers.create!(name:"Doxford",dc_code:"DXS")
  dc3=i2.data_centers.create!(name:"E-Shelter",dc_code:"EDC")
  dc4=i2.data_centers.create!(name:"Russelsheim",dc_code:"DEG")
  dc5=i3.data_centers.create!(name:"Shinsuna",dc_code:"JPTLJ")
  dc6=i4.data_centers.create!(name:"Roosendal",dc_code:"NLR")
  dc7=i4.data_centers.create!(name:"Muizen",dc_code:"BEL")
  dc8=i5.data_centers.create!(name:"Tulsa",dc_code:"TUL")
  
  #3PARs
  dcs = [dc1,dc2,dc3,dc4,dc5,dc6,dc7,dc8]
  pars = []
  20.times do |n|
    data_center = dcs.sample
    i = 1
    name = "#{data_center.dc_code}3PAR#{i}"
    while pars.include? name do
      i+=1
      name = "#{data_center.dc_code}3PAR#{i}"
    end
    pars << name
    model = ["V400", "7400", "8440"].sample
    serial =  Random.rand(999999999).to_s
    firmware = ["3.2.1 MU5", "3.2.2 MU2", "3.1.3 MU3"].sample
    space_total = Random.rand(500..1000)
    space_available = Random.rand(0..500)
    space_used = space_total - space_available
    Resource::Storage::A3Par::Array.create!(
      name:name,
      model:model,
      serial:serial,
      firmware:firmware,
      space_total:space_total,
      space_available:space_available,
      space_used:space_used,
      data_center:data_center
    )
  end
  
  #EVAs
  evas = []
  10.times do |n|
    data_center = dcs.sample
    i = 1
    name = "#{data_center.dc_code}EVA#{i}"
    while evas.include? name do
      i+=1
      name = "#{data_center.dc_code}EVA#{i}"
    end
    evas << name
    model = ["8400", "6400"].sample
    serial_tmp =  SecureRandom.hex(11)
    serial = "5001-#{serial_tmp[0..3]}-#{serial_tmp[4..7]}-#{serial_tmp[8..10]}0".upcase
    firmware = ["11001100", "11300000"].sample
    space_total = Random.rand(50..100)
    space_available = Random.rand(0..50)
    space_used = space_total - space_available
    Resource::Storage::Eva::Array.create!(
      name:name,
      model:model,
      serial:serial,
      firmware:firmware,
      space_total:space_total,
      space_available:space_available,
      space_used:space_used,
      data_center:data_center
    )
  end
end