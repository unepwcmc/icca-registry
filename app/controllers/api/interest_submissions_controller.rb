class Api::InterestSubmissionsController < ApplicationController
  protect_from_forgery

  def create
    InterestSubmission.create(
      params.permit(:icca_name, :icca_size, :country, :can_contact, :email)
    )
    head 201
  end
end
