require 'rails_helper'

feature "Positive req_purchase path" do
  
  # Закупка, это параллельное согласование

  scenario "main req_purchase scenario" do  

    visit "/"

    # Менеджер 1 заводит заявку на закупку

    login "manager1@test.co", "testtest"
    expect(page).to have_content "Менеджер Один"
    expect(page).to have_css("h2", text: "Главная")
    expect(page).to have_link("Заявки на закупку", href: req_purchases_path)

    visit new_req_purchase_path
    expect(page).to have_css("h2", text: "Создать заявку на закупку")

    fill_in "req_purchase_name", with: "Новая заявка на закупку"
    fill_in "req_purchase_money", with: "999999"
    click_button "save" 
    expect(page).to have_css("h2", text: "Просмотр заявки на закупку")
    expect(page).to have_css("p", text: "new")  
    expect(page).to have_css("p", text: "999 999,00")
    expect(page).to have_link("Редактировать")

    click_link('Редактировать')
    expect(page).to have_css("h2", text: "Редактировать заявку на закупку")

    click_button('initiate')
    expect(page).to have_css("h2", text: "Просмотр заявки на закупку")
    expect(page).to have_css("b", text: "approve, disapprove") 
    expect(page).to have_css("b", text: "Шеф Один")      
    expect(page).to have_css("b", text: "Шеф Два")      
    expect(page).to have_css("p", text: "wait_approval")
    expect(page).to have_css("p", text: "999 999,00")

    click_link "log_out"

    # Шеф 1 согласует заявку

    login "chief1@test.co", "testtest"
    expect(page).to have_content "Шеф Один"
    expect(page).to have_css("h2", text: "Главная")
    expect(page).to have_link("Заявки на закупку", href: req_purchases_path)
    
    visit req_purchases_path
    expect(page).to have_css("h2", text: "Заявки на закупку")
    expect(page).to have_css("td", text: "Новая заявка на закупку")

	within ".table" do
	  first(:link).click
	end
	expect(page).to have_css("h2", text: "Редактировать заявку на закупку")
    expect(page).to have_selector("input[value='wait_approval']")
    expect(page).to have_selector("input[value='Новая заявка на закупку']")
    expect(page).to have_selector("input[value='999999']")

    click_button "approve" 
    expect(page).to have_css("h2", text: "Просмотр заявки на закупку")
    expect(page).to have_css("b", text: "approve, disapprove")  
    expect(page).to have_css("b", text: "Шеф Два")
    expect(page).to have_css("p", text: "wait_approval")  
    expect(page).to have_css("p", text: "999 999,00")

    click_link "log_out" 

    # Шеф 2 согласует заявку

    login "chief2@test.co", "testtest"
    expect(page).to have_content "Шеф Два"
    expect(page).to have_css("h2", text: "Главная")
    expect(page).to have_link("Заявки на закупку", href: req_purchases_path)
    
    visit req_purchases_path
    expect(page).to have_css("h2", text: "Заявки на закупку")
    expect(page).to have_css("td", text: "Новая заявка на закупку")

    within ".table" do
      first(:link).click
    end
    expect(page).to have_css("h2", text: "Редактировать заявку на закупку")
    expect(page).to have_css("b", text: "Шеф Два")    
    expect(page).to have_selector("input[value='wait_approval']")
    expect(page).to have_selector("input[value='Новая заявка на закупку']")
    expect(page).to have_selector("input[value='999999']")

    click_button "approve" 
    expect(page).to have_css("h2", text: "Просмотр заявки на закупку")
    expect(page).to have_css("p", text: "finish_approved")  
    expect(page).to have_css("p", text: "Новая заявка на закупку")  
    expect(page).to have_css("p", text: "999 999,00")

    click_link "log_out" 
  end

  private

  def login(email, password)
    fill_in "user_email", with: email
    fill_in "user_password", with: password
    click_button "log_in"   
  end

end