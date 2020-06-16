class Api::InterestSubmissionsController < ApplicationController
  invisible_captcha only: [:create], honeypot: :last_name
  protect_from_forgery with: :exception

  def create
    submission = InterestSubmission.create(params.permit(:icca_name, :icca_size, :country, :can_contact, :email))

    SubmissionMailer.create(submission).deliver
    head 201
  end
end
