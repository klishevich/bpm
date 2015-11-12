#encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'csv'

puts 'Delete History'
History.delete_all

puts 'Delete Assignments'
Assignment.delete_all

puts 'Delete ReqReassigns'
ReqReassign.delete_all

puts 'Delete ReqPurchases'
ReqPurchase.delete_all

puts 'Delete WorkgroupMembers'
InfWorkgroupMember.delete_all

puts 'Delete ReqWorkgroups'
ReqWorkgroup.delete_all

puts 'Delete Clients'
Client.delete_all

connection = ActiveRecord::Base.connection()
puts 'Update units delete manager values'
connection.execute("update units set manager_id = null")

puts 'Delete UserRoles'
connection.execute("delete from users_roles")

puts 'Delete Roles'
Role.delete_all

puts 'Delete Users'
User.delete_all

puts 'Delete Units'
Unit.delete_all

puts 'Roles Creation'
Role.create([
  { name: "Клиентский менеджер", code: "client_manager"},
  { name: "Руководитель клиентского отдела", code: "chief_client_manager"}
])
puts 'Create admin user: adm@test.co/testtest'
User.create({ email: "adm@test.co", password:"testtest", password_confirmation:"testtest", 
	name: "Реальный админ", admin: true})

puts 'Units Creation'
CSV.foreach("db/import/OgrStructureImport.csv", { encoding: "UTF-8", headers: true, 
	header_converters: :symbol, converters: :all, :col_sep => ";" }) do |row|
  Unit.create(row.to_hash) if !row.field(1).blank?
end

puts 'Users Creation'
CSV.foreach("db/import/UsersImport.csv", { encoding: "UTF-8", headers: true, 
	header_converters: :symbol, converters: :all, :col_sep => ";" }) do |row|
  User.create(row.to_hash) if !row.field(1).blank?
end

puts 'Update parent unit'
connection.execute("update units as u 
					set parent_id = parent.id
					from units as parent 
					where u.parent_code = parent.code")

puts 'Update unit manager'
connection.execute("update units as u
					set manager_id = us.id
					from users as us
					where us.code = u.manager_code")

puts 'Update user department (unit)'
connection.execute("update users as us
					set unit_id = u.id
					from units as u
					where us.unit_code = u.code")

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
  { name: "Перезакрепление первого пользователя",last_user_id: user1.id, client_id: client1.id, old_manager_id: user1.id, 
  	new_manager_id: user2.id, money: 10_000_000, info: "test1"},
  { name: "Перезакрепление второго пользователя", last_user_id: user2.id, client_id: client2.id, old_manager_id: user2.id, 
  	new_manager_id: user1.id, money: 123_000_000, info: "test2"}
])

ReqPurchase.create([
  { name: "Закупка первого", last_user_id: user1.id, money: 1_000},
  { name: "Закупка второго", last_user_id: user2.id, money: 2_000}
])

