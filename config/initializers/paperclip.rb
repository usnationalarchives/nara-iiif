# This file sets default configuration for Paperclip attached files
# You can override any of these settings on a per-attachment basis
# by adding the setting to the has_attached_file hash in the model definition

Paperclip::Attachment.default_options.merge!({

  # Store files on Amazon S3
  storage: :s3,

  # The bucket name and AWS keys come from the environment
  bucket: ENV.fetch("S3_BUCKET_NAME"),
  s3_credentials: {
    access_key_id: ENV.fetch("AWS_ACCESS_KEY_ID"),
    secret_access_key: ENV.fetch("AWS_SECRET_ACCESS_KEY"),
  },

  # By default, serve all images over HTTPS. You can specify HTTP here,
  # or set an empty string, meaning to use // as the protocol for files,
  # so it will scheme-match either HTTPS or HTTP
  s3_protocol: "https",

  # The bucket should be located in us-east-1 to be the closest to Heroku
  s3_region: "us-east-1",

  # By default individual files are publicly readable
  s3_permissions: "public-read",

  # The symbol-string here means the default domain URL to a file will
  # be https://my-bucket-name.s3.amazonaws.com/
  url: ":s3_domain_url",

  # Append a timestamp like ?304050 to the end of URLs
  use_timestamp: true,

  # The default path to a file is interpolated with:
  # class      -> the tableize'd name of the model (see String#tableize)
  # id         -> the ID of the object
  # attachment -> the name of the attached file field
  # style      -> the thumbnail/export style name
  # extension  -> the file extension
  path: ":class/:id/:attachment/:style.:extension",

  # Run these processors by default (assumes most attachments are images)
  processors: [:thumbnail, :jpegtran],

  # Always strip metadata
  convert_options: {
    all: "-strip",
  },

  # Set default cache control headers for
  # uploaded assets
  s3_headers: {
    "Cache-Control" => "public, max-age=#{356.days}",
    "Expires" => 365.days.from_now.httpdate
  },

})

# Override the :extension interpolator so that original filenames are downcased
Paperclip.interpolates :extension do |attachment, style_name|
  ((style = attachment.styles[style_name.to_s.to_sym]) && style[:format]) ||
  File.extname(attachment.original_filename.downcase).gsub(/\A\.+/, "")
end

# Support interpolating a UUID field
Paperclip.interpolates :uuid do |attachment, style_name|
  attachment.instance.uuid
end

# Fix a Paperclip regression
# https://github.com/thoughtbot/paperclip/issues/2253
module Paperclip
  class HttpUrlProxyAdapter < UriAdapter
    def initialize(target)
      super(URI(target))
    end
  end
end
