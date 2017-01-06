require 'uri'

class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)

    return if value.blank?

    record.errors[attribute] << (options[:message] || 'must be a valid URL') unless url_valid?(value)
  end

  def url_valid?(url)
    uri = URI.parse(url)
    uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
  rescue URI::InvalidURIError
    false
  end
end