class Api::InterestSubmissionsController < ApplicationController
  invisible_captcha only: [:create], honeypot: :last_name, on_spam: :spam_caught
  protect_from_forgery with: :exception

  def create
    submission = InterestSubmission.create(params.permit(:icca_name, :icca_size, :country, :can_contact, :email))

    SubmissionMailer.create(submission).deliver_now
    head 201
  end

  private 


  def spam_caught
    redirect_to root_path
  end
end
