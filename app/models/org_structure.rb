class OrgStructure
  def self.get_chief(user_email)
  	User.where(email: user_email).first.unit.manager.email
  	# if (user_email == 'manager1@test.co')
  	# 	u = 'chief1@test.co'
  	# elsif (["manager2@test.co", "manager22@test.co"].include? user_email)
  	# 	u = 'chief2@test.co'
  	# else
  	# 	u = "ceo@test.co"
  	# end
  end  
end