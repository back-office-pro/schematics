# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'pwned'

Pwned.default_request_options = { read_timeout: 5, open_timeout: 5 }
