require 'rails_helper'

feature "User logs in and logs out" do

  # `js: true` spec metadata means this will run using the `:selenium`
  # browser driver configured in spec/support/capybara.rb
  scenario "with correct details" do

    create(:user, email: "manager1@test.co", name: "Mike Klishevich", 
      password: "testtest")

    visit "/"

    expect(page).to have_css("h2", text: "Вход")
    expect(current_path).to eq(new_user_session_path)    

    login "manager1@test.co", "testtest"

    # expect(page).to have_selector('a.font-bold', text: 'Mike')

    expect(page).to have_content "Mike Klishevich"

    expect(page).to have_content "Главная"

    click_link "log_out"

    expect(page).to have_css("h2", text: "Вход")

  end

  # scenario "unconfirmed user cannot login" do

  #   create(:user, skip_confirmation: false, email: "e@example.tld", password: "test-password")

  #   visit new_user_session_path

  #   login "e@example.tld", "test-password"

  #   expect(current_path).to eq(new_user_session_path)
  #   expect(page).not_to have_content "Signed in successfully"
  #   expect(page).to have_content "You have to confirm your email address before continuing"
  # end

  # scenario "locks account after 3 failed attempts" do

  #   email = "someone@example.tld"
  #   create(:user, email: email, password: "somepassword")

  #   visit new_user_session_path

  #   login email, "1st-try-wrong-password"
  #   expect(page).to have_content "Invalid email or password"
    
  #   login email, "2nd-try-wrong-password" 
  #   expect(page).to have_content "You have one more attempt before your account is locked"

  #   login email, "3rd-try-wrong-password"
  #   expect(page).to have_content "Your account is locked."

  # end

  private

  def login(email, password)
    fill_in "user_email", with: email
    fill_in "user_password", with: password
    click_button "log_in"   
  end

end