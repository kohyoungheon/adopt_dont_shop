require 'rails_helper'

RSpec.describe 'the pets index' do
  it 'lists all the pets with their attributes' do
    shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    pet_1 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)
    pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)

    visit "/pets"

    expect(page).to have_content(pet_1.name)
    expect(page).to have_content(pet_1.breed)
    expect(page).to have_content(pet_1.age)
    expect(page).to have_content(shelter.name)

    expect(page).to have_content(pet_2.name)
    expect(page).to have_content(pet_2.breed)
    expect(page).to have_content(pet_2.age)
    expect(page).to have_content(shelter.name)
  end

  it 'only lists adoptable pets' do
    shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    pet_1 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)
    pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)
    pet_3 = Pet.create(adoptable: false, age: 2, breed: 'saint bernard', name: 'Beethoven', shelter_id: shelter.id)

    visit "/pets"

    expect(page).to_not have_content(pet_3.name)
  end

  it 'displays a link to edit each pet' do
    shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    pet_1 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)
    pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)

    visit '/pets'

    expect(page).to have_content("Edit #{pet_1.name}")
    expect(page).to have_content("Edit #{pet_2.name}")

    click_link("Edit #{pet_1.name}")

    expect(page).to have_current_path("/pets/#{pet_1.id}/edit")
  end

  it 'displays a link to delete each pet' do
    shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    pet_1 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)
    pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)

    visit '/pets'

    expect(page).to have_content("Delete #{pet_1.name}")
    expect(page).to have_content("Delete #{pet_2.name}")

    click_link("Delete #{pet_1.name}")

    expect(page).to have_current_path("/pets")
    expect(page).to_not have_content(pet_1.name)
  end

  it 'has a text box to filter results by keyword' do
    visit "/pets"
    expect(page).to have_button("Search")
  end

  it 'lists partial matches as search results' do
    shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    pet_1 = Pet.create(adoptable: true, age: 7, breed: 'sphynx', name: 'Bare-y Manilow', shelter_id: shelter.id)
    pet_2 = Pet.create(adoptable: true, age: 3, breed: 'domestic pig', name: 'Babe', shelter_id: shelter.id)
    pet_3 = Pet.create(adoptable: true, age: 4, breed: 'chihuahua', name: 'Elle', shelter_id: shelter.id)

    visit "/pets"

    fill_in 'Search', with: "Ba"
    click_on("Search")

    expect(page).to have_content(pet_1.name)
    expect(page).to have_content(pet_2.name)
    expect(page).to_not have_content(pet_3.name)
  end

  #User Story 2
  describe "When I visit /pets," do
    it "displays a link to 'Start an Application'" do
      visit "/pets"
      within ("#pet-index") do
        expect(page).to have_selector(:button, "Start an Application")
      end
    end

    it "clicking the link redirects me to /applications/new" do
      visit "/pets"
      within ("#pet-index") do
        click_on("Start an Application")
        expect(page).to have_current_path("/applications/new")
      end
    end
  
    it "displays a form with space for attributes" do
      visit "/applications/new"
      within ("#create-app-form") do
        expect(page).to have_content("Name")
        expect(page).to have_field(:name)
        expect(page).to have_content("Street address")
        expect(page).to have_field(:street_address)
        expect(page).to have_content("City")
        expect(page).to have_field(:city)
        expect(page).to have_content("State")
        expect(page).to have_field(:state)
        expect(page).to have_content("Zip")
        expect(page).to have_field(:zip)
        expect(page).to have_content("Description")
        expect(page).to have_field(:description)
        expect(page).to have_selector(:button, "Create Application")
      end
    end
    it "filling and submitting the form takes me to /applications/:id" do
      visit "/applications/new"
      within ("#create-app-form") do
        fill_in(:name, :with => 'John')
        fill_in(:street_address, :with => '1234 F. Street')
        fill_in(:city, :with => 'Los Angeles')
        fill_in(:state, :with => 'California')
        fill_in(:zip, :with => '80005')
        fill_in(:description, :with => 'I am the best pet owner')
        click_on("Create Application")
      end
      id = Application.last.id
      expect(page).to have_current_path("/applications/#{id}")
    end
    it "displays submitted info with an 'In Progress' indicator" do
      visit "/applications/new"
      within ("#create-app-form") do
        fill_in(:name, :with => 'John')
        fill_in(:street_address, :with => '1234 F. Street')
        fill_in(:city, :with => 'Los Angeles')
        fill_in(:state, :with => 'California')
        fill_in(:zip, :with => '80005')
        fill_in(:description, :with => 'I am the best pet owner')
        click_on("Create Application")
      end
      id = Application.last.id
      expect(page).to have_current_path("/applications/#{id}")
      within('#app-show') do
        expect(page).to have_content("Name: John")
        expect(page).to have_content("Address: 1234 F. Street")
        expect(page).to have_content("App Status: In Progress")
      end
    end
  end
end
