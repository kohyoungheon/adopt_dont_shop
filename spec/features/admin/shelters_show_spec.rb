require 'rails_helper'
RSpec.describe 'admin shelters' do
  before(:each) do
    @shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create!(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create!(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
    @shelter_1.pets.create!(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @shelter_1.pets.create!(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @shelter_3.pets.create!(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    @pet_1 = @shelter_1.pets.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Bare-y Manilow')
    @pet_2 = @shelter_2.pets.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'George')
    @pet_3 = @shelter_1.pets.create!(adoptable: true, age: 2, breed: 'Mushroom', name: 'Fun Guy')
   
    @application_1 = @pet_1.applications.create!(
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

  @application_3 = @pet_3.applications.create(
    name: "Kylo Ren",
    street_address:  "Laser Street",
    city: "Star Wars City",
    state: "CA",
    zip: "92043",
    description: "I Killed my own father",
    status: "In Progress"
  )

  end

  #User Story 19
  describe "Admin Shelters Show Page" do
    it "has the shelters name and full address" do
      visit "admin/shelters/#{@shelter_1.id}"
      within ('#admin-shelter-info') do
        expect(page).to have_content("#{@shelter_1.name}")
        expect(page).to have_content("#{@shelter_1.city}")
      end
    end
  end

  describe "/admin/shelters/:id" do
    #User Story 22
    it "displays a section for statistics" do
      visit "admin/shelters/#{@shelter_1.id}"
      within ('#admin-shelter-stats') do
        expect(page).to have_content("Statistics:")
      end
    end

    it "displays average age of all adoptable pets for that shelter" do
      visit "admin/shelters/#{@shelter_1.id}"

      within ('#admin-shelter-stats') do
        expect(page).to have_content("Average age of adoptable pets: 2.75")
      end

      visit "admin/shelters/#{@shelter_3.id}"
      within ('#admin-shelter-stats') do
        expect(page).to have_content("Average age of adoptable pets: 8")
      end
    end

    #User Story 23
    it "displays a count of adoptable pets for that shelter" do
      visit "admin/shelters/#{@shelter_1.id}"

      within ('#admin-shelter-stats') do
        expect(page).to have_content("Count of adoptable pets: 4")
      end
      
      visit "admin/shelters/#{@shelter_3.id}"
      within ('#admin-shelter-stats') do
        expect(page).to have_content("Count of adoptable pets: 1")
      end
    end
    #User Story 24
    it "displays the count of adopted pets from that shelter" do
      @shelter_1.pets.create!(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: false)
      visit "admin/shelters/#{@shelter_1.id}"
      within ('#admin-shelter-stats') do
        expect(page).to have_content("Count of pets that have been adopted: 1")
      end
      visit "admin/shelters/#{@shelter_3.id}"
      within ('#admin-shelter-stats') do
        expect(page).to have_content("Count of pets that have been adopted: 0")
      end
    end

    #User Story 25
    it 'has action required section' do
      visit "admin/shelters/#{@shelter_1.id}"
      
      expect(page).to have_content("Action Required")
    end

    it 'has a list of all pets for this shelter that have a pending application' do
      visit "admin/shelters/#{@shelter_1.id}"
      expect(page).to have_content("Bare-y Manilow")
    end

    #User Story 26
    it 'has a link to the admin application show page' do
      visit "admin/shelters/#{@shelter_1.id}"
      click_link("Accept/Reject Application for Fun Guy")
      save_and_open_page
      expect(page).to have_content("Address: Laser Street, Star Wars City CA 92043")
    end
  end
end