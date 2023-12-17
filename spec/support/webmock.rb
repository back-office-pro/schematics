# frozen_string_literal: true

require 'webmock/rspec'

WebMock.disable_net_connect!(
  allow_localhost: true,
  allow: [
    %r{https://api.pwnedpasswords.com},
    %r{https://cdnjs.cloudflare.com/ajax/libs/font-awesome}
  ]
)
