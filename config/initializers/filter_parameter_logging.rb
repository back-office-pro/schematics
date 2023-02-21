# frozen_string_literal: true

Rails.configuration.filter_parameters += %i[passw secret token _key crypt salt certificate otp ssn]
