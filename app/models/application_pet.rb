class ApplicationPet < ApplicationRecord
  belongs_to :application
  belongs_to :pet

  def find_name
    pet.name
  end

  def self.find_application(pet,application)
    where("pet_id = #{pet.id} AND application_id = #{application.id}").all
  end

  def self.findall(pets,application)
    applicationpets = []
    pets.each do |pet|
      applicationpets << where("pet_id = #{pet.id} AND application_id = #{application.id}").first
    end
    applicationpets
  end

  def self.pending_by_shelter(shelter_id)
    joins(:pet).where(approved: [nil, ""]).where("shelter_id = '#{shelter_id}'")
  end
end