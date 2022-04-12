# frozen_string_literal: true

require 'grover'

Grover.configure do |config|
  config.options = {
    cache: false,
    timeout: 0,
    format: 'A4',
    display_header_footer: true,
    margin: {
      top: '48px',
      bottom: '48px',
      left: '16px',
      right: '16px'
    }
  }
end
