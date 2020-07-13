class Admin::InterestSubmissionsController < Comfy::Admin::Cms::BaseController
  require 'csv'

  def index
    @interest_submissions = InterestSubmission.order(created_at: :desc).all
  end

  def download_csv
    interest_submissions_csv = CSV.generate do |csv|
      csv << ["ICCA name", "Country", "ICCA size (km2)", "Email", "Can contact?"]
      InterestSubmission.order(created_at: :desc).all.each do |is|
        csv << [is.icca_name, is.country, is.icca_size, is.email, is.can_contact ? "Yes" : "No"]
      end
    end

    send_data interest_submissions_csv, filename: "interest-submissions.csv"
  end
end

