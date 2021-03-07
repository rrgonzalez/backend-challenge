class ShortUrlController < ApplicationController

  def self.short_url(long_url)
    return '' if long_url.blank?

    access_token = Rails.application.credentials.bitly_access_token
    bitly_client = Bitly::API::Client.new(token: access_token)
    short_link = bitly_client.shorten(long_url)
    short_link.link
  end

end