require 'rails_helper'

RSpec.describe Shelter, type: :model do
  describe 'relationships' do
    it { should have_many(:pets) }
    it { should have_many(:ShelterVeterinarians)}
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:rank) }
    it { should validate_numericality_of(:rank) }
  end

  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    @pet_4 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)
    @pet_5 = @shelter_3.pets.create(name: 'Ann', breed: 'ragdoll', age: 2, adoptable: true)
    @application_1 = @pet_1.applications.create(
      name: "Billy Mays",
      street_address:  "123 Main St",
      city: "Aurora",
      state: "CO",
      zip: "80012",
      description: "I like pets",
      status: "In Progress"
  )
  @application_2 = @pet_3.applications.create(
    name: "Gwen Stefani",
    street_address:  "125 Main St",
    city: "Aurora",
    state: "CO",
    zip: "80012",
    description: "I like pets even more",
    status: "Pending"
  )
  end

  describe 'class methods' do
    describe '#search' do
      it 'returns partial matches' do
        expect(Shelter.search("Fancy")).to eq([@shelter_3])
      end
    end

    describe '#order_by_recently_created' do
      it 'returns shelters with the most recently created first' do
        expect(Shelter.order_by_recently_created).to eq([@shelter_3, @shelter_2, @shelter_1])
      end
    end

    describe '#order_by_number_of_pets' do
      it 'orders the shelters by number of pets they have, descending' do
        expect(Shelter.order_by_number_of_pets).to eq([@shelter_1, @shelter_3, @shelter_2])
      end
    end

    describe "#join_application_pending" do
      it 'joins on pending app and plucks shelter name' do
        application_3 = @pet_1.applications.create(
          name: "Gwen Stefani",
          street_address:  "125 Main St",
          city: "Aurora",
          state: "CO",
          zip: "80012",
          description: "I like pets even more",
          status: "Pending"
        )
        expect(Shelter.join_application_pending.pluck(:name)).to eq(["Aurora shelter", "Fancy pets of Colorado"])

      end
    end

    describe "#order_alpha" do
      it "sorts shelters in reverse alphabetical order" do
        expect(Shelter.order_alpha).to eq([@shelter_2,@shelter_3,@shelter_1])
      end
    end

    describe "#get_name_city" do
      it "gets name" do
        expect(Shelter.get_name("#{@shelter_2.id}")).to eq("RGV animal shelter")
      end
    end

    it 'gets city' do
      expect(Shelter.get_city("#{@shelter_2.id}")).to eq("Harlingen, TX")
    end
  end
  
  describe 'instance methods' do
    describe '.adoptable_pets' do
      it 'only returns pets that are adoptable' do
        expect(@shelter_1.adoptable_pets).to eq([@pet_2, @pet_4])
      end
    end

    describe '.alphabetical_pets' do
      it 'returns pets associated with the given shelter in alphabetical name order' do
        expect(@shelter_1.alphabetical_pets).to eq([@pet_4, @pet_2])
      end
    end

    describe '.shelter_pets_filtered_by_age' do
      it 'filters the shelter pets based on given params' do
        expect(@shelter_1.shelter_pets_filtered_by_age(5)).to eq([@pet_4])
      end
    end

    describe '.pet_count' do
      it 'returns the number of pets at the given shelter' do
        expect(@shelter_1.pet_count).to eq(3)
      end
    end

    describe '.find_avg_age' do
      it 'returns average age of pets at shelter' do
        expect(@shelter_1.find_avg_age).to eq(4)
        expect(@shelter_3.find_avg_age).to eq(5)
      end
    end

    describe '.adoptable_pet_count' do
      it 'returns a count of adoptable pets at shelter' do
        expect(@shelter_1.adoptable_pet_count).to eq(2)
        expect(@shelter_3.adoptable_pet_count).to eq(2)
      end
    end

    describe '.adopted_pet_count' do
      it 'returns a count of adopted pets from shelter' do
        expect(@shelter_1.adopted_pet_count).to eq(1)
        expect(@shelter_3.adopted_pet_count).to eq(0)
      end
    end

    describe '.app_pets_pending' do
      it 'returns app_pets where approved is nil' do
        expect(@shelter_3.app_pets_pending.count).to eq(1)
        expect(@shelter_1.app_pets_pending.count).to eq(1)
        expect(@shelter_2.app_pets_pending.count).to eq(0)
      end
    end
  end
end
