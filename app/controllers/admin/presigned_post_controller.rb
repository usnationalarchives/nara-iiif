class Admin::PresignedPostController < Tolaria::TolariaController

  def create
    presigned_post = new_presigned_post(content_type:params[:content_type])
    fields = presigned_post.fields
    fields[:bucket_name] = ENV.fetch("S3_BUCKET_NAME")
    return render(json:fields.to_json, status:201)
  end

  protected

  def new_presigned_post(content_type:"binary/octet-stream")

    client = Aws::S3::Client.new(
      region: ENV.fetch("S3_REGION"),
      access_key_id: ENV.fetch("AWS_ACCESS_KEY_ID"),
      secret_access_key: ENV.fetch("AWS_SECRET_ACCESS_KEY"),
    )

    bucket = Aws::S3::Bucket.new(ENV.fetch("S3_BUCKET_NAME"), client:client)

    presigned_post = bucket.presigned_post(
      key: "temp/#{SecureRandom.uuid}/${filename}", # ${filename} is a special string that AWS recognizes to preserve the original name
      success_action_status: "201", # Return a HTTP 201 when the upload works
      acl: "public-read", # The URL creates a publically-accessible file
      signature_expiration: 24.hours.from_now, # The post URL expires at this date
      content_type: content_type, # The pre-signed post must include the future mimetype/Content-Type header
    )

    return presigned_post

  end

end
