# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
puts 'Delete ReqReassigns'
ReqReassign.delete_all

puts 'Delete Users'
User.delete_all

puts 'Users Creation'
User.create([
	{ email: "manager1@test.co", password:"mihael1st", password_confirmation:"mihael1st"},
	{ email: "manager2@test.co", password:"mihael1st", password_confirmation:"mihael1st"},
	{ email: "manager22@test.co", password:"mihael1st", password_confirmation:"mihael1st"},
	{ email: "chief1@test.co", password:"mihael1st", password_confirmation:"mihael1st"},
	{ email: "chief2@test.co", password:"mihael1st", password_confirmation:"mihael1st"},
	{ email: "ceo@test.co", password:"mihael1st", password_confirmation:"mihael1st"},
	{ email: "admin@test.co", password:"mihael1st", password_confirmation:"mihael1st"}
])