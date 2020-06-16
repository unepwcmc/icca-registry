# Preview all emails at http://localhost:3000/rails/mailers/submission_mailer
class SubmissionMailerPreview < ActionMailer::Preview
   def create
    # Set up a temporary order for the preview
    submission = InterestSubmission.new(icca_name: "Test", email: "joe@gmail.com", country: 'test', icca_size: "test", can_contact: true, )

    SubmissionMailer.create(submission)
  end
end
