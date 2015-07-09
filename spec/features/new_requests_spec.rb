require 'rails_helper'
require 'pp'

RSpec.describe "NewRequests", :type => :request do
  it "login page is OK" do
    # user = FactoryGirl.create(:user, :username => "mike@gmail.com", :password => "password")
    visit "/"
    # pp "test"
	expect(page).to have_selector('a', text: 'BPM on Rails') 

    fill_in "Email", :with => "manager1@test.co"
    fill_in "Password", :with => "mihael1st"
    click_button "enter"

    expect(page).to have_selector('a.user_email', :text => 'manager1@test.co')
  end
end