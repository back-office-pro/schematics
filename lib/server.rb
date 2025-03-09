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

    def ssl_path
      Pathname.new("/etc/letsencrypt/live/#{domain}")
    end

    def ssl?
      ssl_path.exist?
    end

    def port
      DEFAULT_PORT unless Rails.env.production?
    end
  end
end
