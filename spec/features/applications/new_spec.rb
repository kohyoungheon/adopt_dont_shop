require 'rails_helper'

RSpec.describe "Filling out forms" do
  
 it 'fills out form' do
  visit "/applications/new"

  fill_in "name", with: "Jimbo"
  fill_in "street_address", with: "269 North"
  fill_in "city", with: "Provo"
  fill_in "state", with: "UT"
  fill_in "zip", with: "84606"
  fill_in "description", with: "pass the test please"
  
  click_button "Create Application"
 end

 #User Story 3
 describe "When I visit /applications/new" do
  it "displays a flash message if form is submitted while incomplete and renders the same page again" do
    visit "/applications/new"
    fill_in "name", with: "Jimbo"
    click_button "Create Application"
    expect(page).to have_content("Problems with your application:")
    expect(page).to have_current_path("/applications")
    expect(page).to have_field(:name)
    expect(page).to have_field(:street_address)
    expect(page).to have_field(:city)
    expect(page).to have_field(:state)
    expect(page).to have_field(:zip) 
    expect(page).to have_field(:description)
  end
 end
end