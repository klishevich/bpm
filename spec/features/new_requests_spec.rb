require 'rails_helper'
require 'pp'

RSpec.describe "User", :type => :request do
  it "can login and create request" do
    # user = FactoryGirl.create(:user, :username => "mike@gmail.com", :password => "password")
    visit "/"
    # pp "test"
    expect(page).to have_selector('a', text: 'BPM on Rails') 

    fill_in "user_email", :with => "manager1@test.co"
    fill_in "user_password", :with => "testtest"
    click_button "enter"

    expect(page).to have_selector('a.user_email', :text => 'Manager One')

    visit "/req_reassigns/new"
    expect(page).to have_selector('h1#new')

    fill_in "req_reassign_name", :with => "test1"
    fill_in "req_reassign_inn", :with => "1234567890"
    select 'manager2@test.co', :from => 'req_reassign_manager'
    # fill_in "req_reassign_manager", :with => "manager2@test.co"
    fill_in "req_reassign_money", :with => "1111"
    click_button "save"
    expect(page).to have_selector('h1#show')
  end

end