#encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
puts 'Delete History'
History.delete_all

puts 'Delete Assignments'
Assignment.delete_all

puts 'Delete ReqReassigns'
ReqReassign.delete_all

puts 'Delete ReqPurchases'
ReqPurchase.delete_all

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

user1 = User.where(email: "manager1@test.co").first
user2 = User.where(email: "manager2@test.co").first

puts 'Clients creation'

user1.clients.create([
	{ name: 'ООО "Бизнес-Оптимизация"', inn: "5408290560"},
	{ name: 'Компания Сибирь', inn: "1234567890"},
	{ name: 'Компания Авиалинии', inn: "5408290560"},
	{ name: 'Русский бальзам', inn: "5408290560"}
	])

user2.clients.create([
	{ name: 'Андроповка', inn: "5408290560"},
	{ name: 'Калинка', inn: "1234567890"},
	{ name: 'Рога и копыта', inn: "5408290560"},
	{ name: 'ООО Крупнокалиберный пулемет', inn: "5408290560"}
	])

client1 = Client.where(name: "Компания Сибирь").first
client2 = Client.where(name: "Рога и копыта").first

puts 'ReqReassigns creation'

ReqReassign.create([
  { last_user_id: user1.id, client_id: client1.id, old_manager_id: user1.id, 
  	new_manager_id: user2.id, money: 10_000_000, info: "test1"},
  { last_user_id: user2.id, client_id: client2.id, old_manager_id: user2.id, 
  	new_manager_id: user1.id, money: 123_000_000, info: "test2"}
])

