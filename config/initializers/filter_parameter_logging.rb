# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

Rails.configuration.filter_parameters += %i[
  passw
  email
  secret
  token
  _key
  crypt
  salt
  certificate
  otp
  ssn
  cvv
  cvc
]
