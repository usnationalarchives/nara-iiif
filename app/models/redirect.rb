class Redirect < ApplicationRecord

  include ModalAttributable
  include Normalizeable

  modal_attribute :parameter_preservation_mode, {
    outgoing: "Use parameters set on the Target URI",
    incoming: "Use incoming parameters",
  }

  # ---------------------------------------------------------------------------
  # VALIDATIONS
  # ---------------------------------------------------------------------------

  before_validation do
    squish_attribute! :original_path
    squish_attribute! :target_uri
  end

  # original_path must be valid
  validate do
    begin
      URI.parse(self.original_path)
    rescue URI::InvalidURIError
      errors.add(:original_path, "is not a valid URI, check for spaces or un-encoded characters")
    end
  end

  # target_uri must be valid
  validate do
    begin
      URI.parse(self.target_uri)
    rescue URI::InvalidURIError
      errors.add(:target_uri, "is not a valid URI, check for spaces or un-encoded characters")
    end
  end

  # original_path must be unique
  validates_uniqueness_of :original_path, message:"is an existing redirect, redirects must be unique"

  # original_path must be root-relative
  validate do
    unless errors.any?
      unless parsed_original_path.to_s.first.eql?("/")
        errors.add(:base, %{
          The Original path must be root-relative (it must start with a “/”)
        })
      end
    end
  end

  # If target_uri does not contain a scheme, it must be root-relative
  validate do
    unless errors.any?
      unless parsed_target_uri.scheme.present? || parsed_target_uri.path.first.eql?("/")
        errors.add(:base, %{
          The target URI does not appear to contain a scheme (“http” or “https”)
          and therefore must be root-relative (it must start with a “/”)
        }.squish)
      end
    end
  end

  # Fragments and query params may only be set on the target_uri
  validate do
    unless errors.any?
      if parsed_original_path.query.present? || parsed_original_path.fragment.present?
        errors.add(:base, %{
          The Original Path may not have any query parameters or a fragment set
          (such options would always be ignored by the system)
        }.squish)
      end
    end
  end

  # Fragments and query params will be discarded on the target_uri unless
  # parameter_preservation_mode.outgoing? is true
  validate do
    unless errors.any?
      if parameter_preservation_mode.incoming? && (parsed_target_uri.query.present? || parsed_target_uri.fragment.present?)
        errors.add(:base, %{
          You have specified query parameters or a fragment for the Target URI,
          but those options are not useful because you have set this Redirect to preserve incoming parameters
          (remove the parameters for the Target URI, or change the parameter mode)
        }.squish)
      end
    end
  end

  # If a scheme is provided for target_uri, it may only be HTTP or HTTPS
  validate do
    unless errors.any?
      if parsed_target_uri.scheme.present?
        unless parsed_target_uri.scheme.in? %[http https]
          errors.add(:base, %{
            The Target URI may only have the schemes `http` or `https`
            (it is unsafe to transparently redirect users to other URI schemes such as `ftp` or `ldap`)
          }.squish)
        end
      end
    end
  end

  # ---------------------------------------------------------------------------
  # FORMATTING/INSPECTING
  # ---------------------------------------------------------------------------

  # Returns the original_path field wrapped in a URI class
  def parsed_original_path
    return nil if self.original_path.blank?
    return URI.parse(self.original_path)
  rescue URI::InvalidURIError
    return nil
  end

  # Returns the target_uri field wrapped in a URI class
  def parsed_target_uri
    return nil if self.target_uri.blank?
    return URI.parse(self.target_uri)
  rescue URI::InvalidURIError
    return nil
  end

  # Given an incoming `request_query` string, return the correct URL to
  # target for this redirect instance

  def actualized_redirect_target(request_query)

    if parameter_preservation_mode.outgoing?
      redirect_target = parsed_target_uri
    else
      target_with_overriden_paramters = parsed_target_uri
      target_with_overriden_paramters.query = request_query
      redirect_target = target_with_overriden_paramters
    end

    if redirect_target.query.blank?
      return redirect_target.to_s.gsub("?","") # Prevent empty trailing `?` characters
    else
      return redirect_target.to_s
    end

  end

  # ---------------------------------------------------------------------------
  # TOLARIA
  # ---------------------------------------------------------------------------

  manage_with_tolaria using: {
    icon: "code-fork",
    category: "Settings",
    priority: 1,
    permit_params: [
      :original_path,
      :target_uri,
      :parameter_preservation_mode,
    ]
  }

  def admin_name
    parsed_original_path.to_s
  end

end
