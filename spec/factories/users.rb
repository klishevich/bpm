FactoryGirl.define do
  factory :user do
  	email "someone@example.tld"
    name "Mike"
    password "somepassword"
  end
end

# email: "someone@example.tld", name: "Mike", 
#       password: "somepassword", password_confirmation: "somepassword"