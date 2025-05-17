# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'uri'

class Server
  DEFAULT_PORT = 3000

  class << self
    def domain = ENV.fetch('HOST', 'back-office.pro')

    def url(path: nil) = URI::HTTPS
      .build(host: "www.#{domain}", path:)
      .to_s

    def ssl? = Pathname
      .new("/etc/letsencrypt/live/#{domain}")
      .exist?

    def port
      DEFAULT_PORT unless Rails.env.production? || Rails.env.on_premise?
    end
  end
end
