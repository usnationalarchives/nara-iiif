module Tolaria
  module FormBuildable


    def image(image, hint: nil)
      render(partial:"admin/shared/forms/image_attachment", locals: {
        f: self,
        image_attachment: "#{image}_image_attachment".to_sym,
        hint: hint.present?? hint : "Select an image."
      })
    end


    # Presents a JS-powered file input field that uploads submitted content
    # to a temporary S3 URL, then passes that URL to Paperclip for processing.
    # Underneath, this element is actually a url_field, and it also provides
    # UI to let the user enter the URL manually.
    #
    # IMPORTANT: Your Amazon bucket must be set up to allow CORS POST requests.
    # Your AWS key will need the permission `PutBucketCORS` (this is included in
    # the `S3Full` permission if you have it). This project includes a CORS file
    # for you to push in config/s3/cors.json.
    #
    # Using the AWS CLI:
    #
    # 1. Log into AWS with the client key/secret: `aws configure`
    # 2. Push the config with:
    #
    # ```
    # aws s3api put-bucket-cors  \
    #   --bucket BUCKET_NAME \
    #   --cors-configuration file:///path-to-project/config/s3/cors.json
    # ```
    #
    # You will need to do this for EVERY bucket on the project (dev, review, etc)
    #
    # The uploader allows admins to upload large files to S3 without hitting the
    # Heroku 30-second request timeout. The Rails application will still need to
    # copy the asset from its temporary location to a final one, but copies
    # between machines on AWS are very fast compared to end-user uploads.
    #
    # #### Special Options
    #
    # - `:preview_url` If an existing file can be represented with an image preview
    #    provide a full URL to the preview file. Return nil otherwise.
    # - `:current_url` If a file currently exists, provide a full URL to the
    #   current original. The UI will allow the user to check the current file.
    #   Return nil otherwise.
    def s3_uploader(method, preview_url:nil, current_url:nil)
      render(partial:"admin/shared/forms/s3_uploader", locals: {
        f: self,
        method: method,
        preview_url: preview_url,
        current_url: current_url,
      })
    end

  end
end
