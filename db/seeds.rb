# Admin Wizard
Wizard.find_or_create_by!(email: "dumbledore@great.com") do |wizard|
  wizard.name = "Albus Dumbledore"
  wizard.password = "avada kedavra"
  wizard.date_of_birth = Date.new(2000, 1, 1)
  wizard.bio = "The greatest wizard of all time."
  wizard.muggle_relatives = true
  wizard.is_admin = true
end

# Regular Wizard
Wizard.find_or_create_by!(email: "harry@hogwarts.com") do |wizard|
  wizard.name = "Harry Potter"
  wizard.password = "Potter007"
  wizard.date_of_birth = Date.new(2000, 7, 31)
  wizard.bio = "The Boy Who Lived. Courageous and determined."
  wizard.muggle_relatives = true
  wizard.is_admin = false
end
