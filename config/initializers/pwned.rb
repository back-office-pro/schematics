# frozen_string_literal: true

require 'pwned'

Pwned.default_request_options = { read_timeout: 5, open_timeout: 5 }
