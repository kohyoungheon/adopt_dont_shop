require 'rails_helper'

RSpec.describe Application, type: :model do
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
      status: "In Progress"
  )

  application_2.change_status_to_pending

  expect(application_2.status).to eq("Pending")
  end
end