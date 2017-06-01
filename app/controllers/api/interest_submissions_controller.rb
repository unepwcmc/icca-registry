class Api::InterestSubmissionsController < ApplicationController
  invisible_captcha only: [:create], honeypot: :last_name
  protect_from_forgery with: :exception

  def create
    InterestSubmission.create(
      params.permit(:icca_name, :icca_size, :country, :can_contact, :email)
    )
    head 201
  end
end
