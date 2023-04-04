class ApplicationsController < ApplicationController
  
  def show
    @application = Application.find(params[:id])
    @pets = Pet.filter_by_name(params,@application)
    @pet_filtered = Pet.filter_by_name(params,@application)
  end

  def new
    
  end

  def create
    app = Application.new(application_params)
    if app.save
      redirect_to "/applications/#{app.id}"
    else
      flash[:notice] = "Application not created: Required information missing."
      render :new
    end
  end

  def update
    application = Application.find(params[:id])
    application.update(application_params)
    if params["commit"]
      application = Application.find(params[:id])
      application.change_status_to_pending
    end
    if params[:pet_id]
      pet = Pet.find(params[:pet_id])
      ApplicationPet.create!(pet: pet, application: application)
    end
    redirect_to "/applications/#{application.id}"
    application.save
  end

  def edit
    @application = Application.find(params[:id])
  end

  private
  def application_params
    params.permit(:name, :street_address, :city, :state, :zip, :description, :status)
  end
end