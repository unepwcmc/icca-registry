class SubmissionMailer < ActionMailer::Base

  def create(submission)
    @submission = submission
    @can_contact = @submission.can_contact ? 'Yes' : 'No'
    mail(
        to: t("home_page.destination_email_address"), 
        from: Rails.application.credentials[Rails.env.to_sym][:mailer_username], 
        subject: "New ICCA site: #{@submission.icca_name}"
    )
  end
end
