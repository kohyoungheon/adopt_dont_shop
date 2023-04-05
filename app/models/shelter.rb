class Shelter < ApplicationRecord
  validates :name, presence: true
  validates :rank, presence: true, numericality: true
  validates :city, presence: true

  has_many :pets, dependent: :destroy
  has_many :ShelterVeterinarians

  def self.order_alpha
    find_by_sql("SELECT shelters.* FROM shelters ORDER BY shelters.name desc")
  end

  def self.order_by_recently_created
    order(created_at: :desc)
  end

  def self.order_by_number_of_pets
    select("shelters.*, count(pets.id) AS pets_count")
      .joins("LEFT OUTER JOIN pets ON pets.shelter_id = shelters.id")
      .group("shelters.id")
      .order("pets_count DESC")
  end

  def self.join_application_pending
    joins(pets: :applications).where("status = 'Pending'").order("name")
  end
  
  def self.get_name(id)
    Shelter.find_by_sql("SELECT name AS name FROM shelters WHERE id = #{id}").first.name
  end
  
  def self.get_city(id)
    Shelter.find_by_sql("SELECT city AS city FROM shelters WHERE id = #{id}").first.city
  end

  def pet_count
    pets.count
  end

  def adoptable_pets
    pets.where(adoptable: true)
  end

  def alphabetical_pets
    adoptable_pets.order(name: :asc)
  end

  def shelter_pets_filtered_by_age(age_filter)
    adoptable_pets.where('age >= ?', age_filter)
  end


  def find_avg_age
    pets.where("adoptable = #{true}").average(:age).to_f.round(2)
  end

  def self.join_application_pending
    distinct.joins(pets: :applications).where("status = 'Pending'").order(:name).pluck("name")
  end

  def adoptable_pet_count
    pets.where("adoptable = #{true}").count
  end

  def adopted_pet_count
    pets.where("adoptable = #{false}").count
  end

  # def self.sort_alphabetically
  #   Shelter.order(:)
  # end
end
