require 'rails_helper'

RSpec.describe 'admin shelters' do
  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
    @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    @pet_1 = @shelter_1.pets.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Bare-y Manilow')
    @pet_2 = @shelter_2.pets.create(adoptable: true, age: 55, breed: 'Jimmy', name: 'Rainey St Killer')
    @pet_3 = @shelter_3.pets.create(adoptable: true, age: 9, breed: 'Cow', name: 'Real Human Boy')
    @pet_4 = @shelter_1.pets.create(adoptable: true, age: 4, breed: 'Rotweiler', name:'Rachet')

    @application_1 = @pet_1.applications.create(
      name: "Billy Mays",
      street_address:  "123 Main St",
      city: "Aurora",
      state: "CO",
      zip: "80012",
      description: "I like pets",
      status: "Pending"
  )
  @application_2 = @pet_1.applications.create(
    name: "Gwen Stefani",
    street_address:  "125 Main St",
    city: "Aurora",
    state: "CO",
    zip: "80012",
    description: "I like pets even more",
    status: "In Progress"
  )
  @application_3 = @pet_2.applications.create(
    name: "Bob Saget",
    street_address:  "415 Taco BLVD",
    city: "Aurora",
    state: "CO",
    zip: "80012",
    description: "I like Trains",
    status: "Pending"
  )
  @application_4 = @pet_3.applications.create(
    name: "Pet Two Futuer Owner",
    street_address:  "420 Main St",
    city: "Texas",
    state: "MT",
    zip: "42022",
    description: "I shouldn't own a pet",
    status: "Pending"
  )
  @application_5 = @pet_4.applications.create(
    name: "Dr. Doofenshmirtz",
    street_address:  "123 Center St",
    city: "Denver",
    state: "CO",
    zip: "80001",
    description: "PERRY THE PLATYPUS",
    status: "Pending"
  )
  end

  it 'shows shelters with pending applications' do
    visit '/admin/shelters' 
    
    expect(page).to have_content("Shelters with Pending applications:\n#{@shelter_1.name}")
  end

  #User Story 10
  describe "When i visit /admin/shelters" do
    it "displays all shelters in reverse alphabetical order" do
      visit '/admin/shelters' 
      expect(@shelter_2.name).to appear_before(@shelter_3.name)
      expect(@shelter_3.name).to appear_before(@shelter_1.name)
    end
  end

  #User Story 19
  describe "Admin Shelters Show Page" do
    it "has the shelters name and full address" do
      visit "admin/shelters/#{@shelter_1.id}"

      expect(page).to have_content("#{@shelter_1.name}")
      expect(page).to have_content("#{@shelter_1.city}")
    end
  end

  #user Story 20
  describe "Admin Shelters Show Page" do
    it 'lists shelters alphabetically and distinctly' do
      visit "/admin/shelters"
      
      expect(page).to have_content("Aurora shelter Fancy pets of Colorado RGV animal shelter")
    end
  end
end

    #User Story 21
    it "displays each shelter as a link to that shelter show page" do
      @application_3 = @pet_2.applications.create!(name: "Alex Smith",street_address:  "123 Grove St",city: "Boulder",state: "CO",zip: "80012",description: "I like pets",status: "Pending")
      visit "admin/shelters"
      click_link("Aurora shelter")
      expect(page).to have_current_path("/shelters/#{@shelter_1.id}")

      visit "admin/shelters"
      click_link("RGV animal shelter")
      expect(page).to have_current_path("/shelters/#{@shelter_2.id}")
    end
  end


end