class Document < ApplicationRecord

  include UniquelyIdentifiable

  # --------------------------------------------------------------------------
  # ATTRIBUTES/ASSOCIATIONS
  # --------------------------------------------------------------------------

  has_attached_file :attachment, {
    processors: [], # No processors, can be anything
    path: "documents/:id/:uuid.:extension",
  }

  # --------------------------------------------------------------------------
  # VALIDATION
  # --------------------------------------------------------------------------

  validates_presence_of :title
  validates_attachment_presence :attachment
  do_not_validate_attachment_file_type :attachment

  validate :document_extension_must_be_provided
  def document_extension_must_be_provided
    if document_extension.blank?
      errors.add(:attachment, "must include an extension, rename the file to include an extension and try uploading again")
    end
  end

  # -----------------------------------------------------------------------------
  # Callbacks
  # -----------------------------------------------------------------------------

  # We have to set this header after save because it’s determined dynamically
  # from the original filename. Paperclip doesn't make this filename available
  # in the s3_headers proc until after the object is saved.
  # We're going to copy an S3 object onto itself with new headers.
  # This causes an HTTP request to be sent to S3, but does not load the file into memory.
  after_save :set_content_dispositon_header!
  def set_content_dispositon_header!
    s3_object = attachment.s3_object
    s3_object.copy_to({
      metadata_directive: "REPLACE",
      key: s3_object.key,
      bucket: ENV.fetch("S3_BUCKET_NAME"),
      acl: "public-read",
      cache_control: "public, max-age=#{356.days}",
      expires: 365.days.from_now.httpdate,
      content_disposition: %{attachment; filename="#{self.content_disposition_filename}"}
    })
  end

  # --------------------------------------------------------------------------
  # FORMATTING
  # --------------------------------------------------------------------------

  def content_disposition_filename
    "#{title}#{document_extension}".gsub(%{"},%{})
  end

  def document_extension
    File.extname(attachment_file_name.to_s).downcase
  end

  def display_name
    title.truncate(30, omission:"…")
  end

  # --------------------------------------------------------------------------
  # TOLARIA
  # --------------------------------------------------------------------------

  manage_with_tolaria using: {
    icon: "file-text-o",
    category: "Media",
    default_order: "title asc",
    priority: 10,
    permit_params: [
      :title,
      :attachment
    ]
  }

end
