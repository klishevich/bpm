require 'rails_helper'

feature "Positive req_reassign path" do

  scenario "main scenario" do  

    visit "/"

    # Менеджер 1 заводит заявку на перезакрепление

    login "manager1@test.co", "testtest"
    expect(page).to have_content "Менеджер Один"
    expect(page).to have_css("h2", text: "Главная")
    expect(page).to have_link("Заявки на перезакрепление", href: req_reassigns_path)

    visit new_req_reassign_path
    expect(page).to have_css("h2", text: "Создать заявку на перезакрепление")

    fill_in "req_reassign_name", with: "Новая заявка на перезакрепление"
    select "Компания Авиалинии", :from => "req_reassign_client_id"
    select "Менеджер Два", :from => "req_reassign_new_manager_id"
    fill_in "req_reassign_money", with: "999999"
    fill_in "req_reassign_info", with: "nope"
    click_button "save" 
    expect(page).to have_css("h2", text: "Просмотр заявки на перезакрепление")
    expect(page).to have_css("p", text: "new")  
    expect(page).to have_css("p", text: "Компания Авиалинии")
    expect(page).to have_css("p", text: "999")
    expect(page).to have_link("Редактировать")

    click_link('Редактировать')
    expect(page).to have_css("h2", text: "Редактировать заявку на перезакрепление")

    click_button('initiate')
    expect(page).to have_css("h2", text: "Просмотр заявки на перезакрепление")
    expect(page).to have_css("p", text: "wait_approval")  
    expect(page).to have_css("p", text: "Компания Авиалинии")
    expect(page).to have_css("p", text: "999")

    click_link "log_out"

    # Менеджер 2 согласует заявку

    login "manager2@test.co", "testtest"
    expect(page).to have_content "Менеджер Два"
    expect(page).to have_css("h2", text: "Главная")
    expect(page).to have_link("Заявки на перезакрепление", href: req_reassigns_path)
    
    visit req_reassigns_path
    expect(page).to have_css("h2", text: "Заявки на перезакрепление")
    expect(page).to have_css("td", text: "Компания Авиалинии")

	within ".table" do
	  first(:link).click
	end
	expect(page).to have_css("h2", text: "Редактировать заявку на перезакрепление")
    expect(page).to have_selector("input[value='wait_approval']")
    expect(page).to have_selector("input[value='999999']")

    click_button "approve" 
    expect(page).to have_css("h2", text: "Просмотр заявки на перезакрепление")
    expect(page).to have_css("b", text: "Шеф Два")
    expect(page).to have_css("p", text: "approved")  
    expect(page).to have_css("p", text: "Компания Авиалинии")
    expect(page).to have_css("p", text: "999")

    click_link "log_out"

    # Шеф 2 согласует заявку

    login "chief2@test.co", "testtest"
    expect(page).to have_css("strong", text: "Шеф Два")
    expect(page).to have_css("h2", text: "Главная")
    expect(page).to have_link("Заявки на перезакрепление", href: req_reassigns_path)
    
    visit req_reassigns_path
    expect(page).to have_css("h2", text: "Заявки на перезакрепление")
    expect(page).to have_css("td", text: "Компания Авиалинии")

    within ".table" do
      first(:link).click
    end
    expect(page).to have_css("h2", text: "Редактировать заявку на перезакрепление")
    expect(page).to have_selector("input[value='approved']")
    expect(page).to have_selector("input[value='999999']")

    click_button "accept" 
    expect(page).to have_css("h2", text: "Просмотр заявки на перезакрепление")
    expect(page).to have_css("b", text: "Админ")
    expect(page).to have_css("p", text: "approved")  
    expect(page).to have_css("p", text: "Компания Авиалинии")
    expect(page).to have_css("p", text: "999")

    click_link "log_out"

    # Админ закрывает заявку

    login "admin@test.co", "testtest"
    expect(page).to have_css("strong", text: "Админ")
    expect(page).to have_css("h2", text: "Главная")
    expect(page).to have_link("Заявки на перезакрепление", href: req_reassigns_path)
    
    visit req_reassigns_path
    expect(page).to have_css("h2", text: "Заявки на перезакрепление")
    expect(page).to have_css("td", text: "Компания Авиалинии")

    within ".table" do
      first(:link).click
    end
    expect(page).to have_css("h2", text: "Редактировать заявку на перезакрепление")
    expect(page).to have_selector("input[value='accepted_approved']")
    expect(page).to have_selector("input[value='999999']")

    click_button "close" 
    expect(page).to have_css("h2", text: "Просмотр заявки на перезакрепление")
    expect(page).to have_css("p", text: "closed")  
    expect(page).to have_css("p", text: "Компания Авиалинии")
    expect(page).to have_css("p", text: "999")   

  end

  private

  def login(email, password)
    fill_in "user_email", with: email
    fill_in "user_password", with: password
    click_button "log_in"   
  end

end