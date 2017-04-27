class Api::InterestSubmissionsController < ApplicationController
  def create
    InterestSubmission.create(
      params.permit(:icca_name, :icca_size, :country, :can_contact, :email)
    )
    head 201
  end
end
