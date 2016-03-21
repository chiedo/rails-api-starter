#
# SEED DATA
# 

# USERS 
User.delete_all
test      = User.create!(id: 1, name: 'Bob', email: "test@test.com", username: "test", password: "testtest", password_confirmation: "testtest" )
testTwo   = User.create!(id: 2, name: 'Bob', email: "bob@test.com",  username: "t@st", password: "testtest", password_confirmation: "testtest" )
testThree = User.create!(id: 3, name: 'Jim', email: "jim@test.com",  username: "tst!", password: "testtest", password_confirmation: "testtest" )
