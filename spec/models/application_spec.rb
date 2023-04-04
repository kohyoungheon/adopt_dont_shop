require 'rails_helper'

RSpec.describe Application, type: :model do
  before(:each) do
    @application_1 = Application.create!(name: "Billy Bob",street_address:  "123 Main St",city: "Aurora",state: "CO",zip: "80012",description: "I like pets",status: "In Progress")
    @application_2 = Application.create!(name: "John Mayer",street_address:  "123 Fake St",city: "Denver",state: "CO",zip: "80012",description: "I like pets",status: "Rejected")  
    @application_3 = Application.create!(name: "Alex Smith",street_address:  "123 Grove St",city: "Boulder",state: "CO",zip: "80012",description: "I like pets",status: "Pending")
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @pet_1 = @shelter_1.pets.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Bare-y Manilow')
    @pet_2 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @pet_3 = @shelter_1.pets.create(name: 'Heisenberg', breed: 'calico', age: 7, adoptable: true)
    @app_pet_1 = ApplicationPet.create!(pet: @pet_1, application: @application_1)
    @app_pet_2 = ApplicationPet.create!(pet: @pet_2, application: @application_1)
  end

  describe "relationship" do
    it {should have_many(:application_pets)}
    it {should have_many(:pets).through(:application_pets)}
    it {should validate_presence_of :name}
    it {should validate_presence_of :street_address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zip}
    it {should validate_presence_of :description}
  end


  it 'changes status to pending' do
    application_2 = Application.create!(
      name: "Charlie Puth",
      street_address:  "124 Main St",
      city: "Aurora",
      state: "CO",
      zip: "80012",
      status: "In Progress",
      description: "I haven't chosen any pets",
      )
      application_2.change_status_to_pending
      expect(application_2.status).to eq("Pending")
  end

  describe "instance methods" do
    describe "confirm_adoptable" do
      it "changes the status of all pets in application pets arguement to adoptable: false" do
        shelter_2 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
        pet_4 = shelter_2.pets.create!(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
        pet_5 = shelter_2.pets.create!(name: 'Heisenberg', breed: 'calico', age: 7, adoptable: true)
        application_4 = Application.create!(name: "John Mayer",street_address:  "123 Fake St",city: "Denver",state: "CO",zip: "80012",description: "I like pets",status: "In Progress")  
        application_5 = Application.create!(name: "Alex Smith",street_address:  "123 Grove St",city: "Boulder",state: "CO",zip: "80012",description: "I like pets",status: "In Progress")
        app_pet_4 = ApplicationPet.create!(pet: pet_4, application: application_4)
        app_pet_5 = ApplicationPet.create!(pet: pet_5, application: application_4)
        application_pets = [app_pet_4, app_pet_5]
        
        expect(pet_4.adoptable).to eq(true)
        expect(pet_5.adoptable).to eq(true)

        Application.confirm_adoptable(application_pets)
    
        expect(pet_4.reload.adoptable).to eq(false)
        expect(pet_5.reload.adoptable).to eq(false)
      end
    end
    describe "update_status" do
      it "updates the status of application depending on if all application_pets have been approved " do
        application_pets = [@app_pet_1, @app_pet_2]
        @app_pet_1.approved = false
        @app_pet_2.approved = true
        @application_1.update_status(application_pets)
        expect(@application_1.status).to eq("Rejected!")

        application_pets = [@app_pet_1, @app_pet_2]
        @app_pet_1.approved = true
        @app_pet_2.approved = true
        @application_1.update_status(application_pets)
        expect(@application_1.status).to eq("Approved!")

        application_pets = [@app_pet_1, @app_pet_2]
        @app_pet_1.approved = nil
        @app_pet_2.approved = true
        @application_1.update_status(application_pets)
        expect(@application_1.status).to eq("In Progress")
      end

      it "calls confirm_adoptable which changes all pets status to adoptable:false if application is Approved!" do
        application_pets = [@app_pet_1, @app_pet_2]
        @app_pet_1.approved = true
        @app_pet_2.approved = true
        @application_1.update_status(application_pets)

        expect(@application_1.status).to eq("Approved!")
        expect(@app_pet_1.pet.reload.adoptable).to eq(false)
        expect(@app_pet_2.pet.reload.adoptable).to eq(false)
      end
    end
  end

  describe "class methods" do
    # describe "::only_pending" do
    #   it "returns applications that are pending only" do
    #     expect(Application.only_pending.first).to eq(@application_3)
    #   end
    # end
  end

end