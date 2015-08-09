#encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
puts 'Delete ReqReassigns'
ReqReassign.delete_all

puts 'Delete Clients'
Client.delete_all

puts 'Delete Users'
User.delete_all

puts 'Users Creation'
User.create([
	{ email: "manager1@test.co", password:"testtest", password_confirmation:"testtest", name: "Менеджер Один"},
	{ email: "manager2@test.co", password:"testtest", password_confirmation:"testtest", name: "Менеджер Два"},
	{ email: "manager22@test.co", password:"testtest", password_confirmation:"testtest", name: "Менеджер Двадцать Два"},
	{ email: "chief1@test.co", password:"testtest", password_confirmation:"testtest", name: "Шеф Один"},
	{ email: "chief2@test.co", password:"testtest", password_confirmation:"testtest", name: "Шеф Два"},
	{ email: "ceo@test.co", password:"testtest", password_confirmation:"testtest", name: "Директор"},
	{ email: "admin@test.co", password:"testtest", password_confirmation:"testtest", name: "Админ"}
])


puts 'ReqReassigns and Clients creation for manager1'
#1
user = User.where(email: "manager1@test.co").first

user.clients.create([
	{ name: 'ООО "Бизнес-Оптимизация"', inn: "5408290560"},
	{ name: 'Компания Сибирь', inn: "1234567890"},
	{ name: 'Компания Авиалинии', inn: "5408290560"},
	{ name: 'Русский бальзам', inn: "5408290560"}
	])

client = Client.first

user.req_reassigns.create([
  { client_id: client.id, old_manager: "manager1@test.co", 
  	manager: "manager2@test.co", money: 10_000_000, info: "test1"}
])

puts 'ReqReassigns and Clients creation for manager2'
user = User.where(email: "manager2@test.co").first
user.clients.create([
	{ name: 'Андроповка', inn: "5408290560"},
	{ name: 'Калинка', inn: "1234567890"},
	{ name: 'Рога и копыта', inn: "5408290560"},
	{ name: 'ООО Крупнокалиберный пулемет', inn: "5408290560"}
	])

client = Client.where(name: "Рога и копыта").first

user.req_reassigns.create([
  { client_id: client.id, old_manager: "manager2@test.co", 
  	manager: "manager1@test.co", money: 123_000_000, info: "test2"}
])
