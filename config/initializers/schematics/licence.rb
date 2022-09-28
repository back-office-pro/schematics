# frozen_string_literal: true

require 'stripe/gateway/licence_loader'

Rails.configuration.to_prepare do
  Schematics::Licence.instance.load(**Stripe::Gateway::LicenceLoader.new.dump)
end
