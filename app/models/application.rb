class Application < ApplicationRecord
  has_many :application_pets
  has_many :pets, through: :application_pets
  validates :name, presence: true
  validates :street_address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true, numericality: true
  validates :description, presence: true
  
  def change_status_to_pending
    self.status = "Pending"
  end

  def update_status(application_pets)
    application = application_pets.first.application
    if application_pets.any? {|ap| ap.approved == false}
      application.update(status: "Rejected!")
    elsif application_pets.any? {|ap| ap.approved == nil}
      application.update(status: "In Progress")
    else
      application.update(status: "Approved!")
      Application.confirm_adoptable(application_pets)
    end
  end

  def self.confirm_adoptable(application_pets)
    application_pets.each do |ap|
      pet = Pet.find(ap.pet_id)
      pet.update_adoptable
      pet.save
    end
  end


  def self.only_pending
    where(status: "Pending")
  end
end