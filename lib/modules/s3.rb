class S3 
  AWS_BUCKET = Rails.application.credentials.dig(:default, :aws_bucket)
  PRODUCTION_DB_PATH = Rails.application.credentials.dig(:default, :production_db_path)

  def initialize 
    @s3 = AWS::S3.new(
      access_key_id: Rails.application.credentials.dig(:default, :aws_access_key),
      secret_access_key: Rails.application.credentials.dig(:default, :aws_secret_access_key)
    )
  end

  def latest_backup
    @s3.buckets[AWS_BUCKET].objects.with_prefix(PRODUCTION_DB_PATH.to_s).to_a.last
  end

  def get_bucket(bucket)
    @s3.buckets[bucket]
  end
end