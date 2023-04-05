require 'rails_helper'

RSpec.describe "Application index" do
  before(:each) do
    @application_1 = Application.create!(
      name: "Charlie Puth",
      street_address:  "124 Main St",
      city: "Aurora",
      state: "CO",
      zip: "80012",
      description: "I like pets even more",
      status: "Pending"
    )
  
     @application_2 = Application.create!(
     name: "Jorge King",
     street_address:  "333 Round Blvd.",
     city: "Sacramento",
     state: "CA",
     zip: "90071",
     status: "Rejected",
     description: "I LOVE pets",
  )
    @application_3 = Application.create!(
      name: "Jorge King",
      street_address:  "333 Round Blvd.",
      city: "Sacramento",
      state: "CA",
      zip: "90071",
      status: "In Progress",
      description: "I LOVE pets",
   )
   @application_4 = Application.create!(
    name: "Charlie Puth",
    street_address:  "124 Main St",
    city: "Aurora",
    state: "CO",
    zip: "80012",
    description: "I like pets even more",
    status: "Pending"
  )
  end

  describe "/applications" do
    it "displays a link to each application" do
      visit "/applications"
      expect(page).to have_content("All Applications (Ease of Access)\n#{@application_1.id} #{@application_2.id} #{@application_3.id} #{@application_4.id}")
    end
  end
end