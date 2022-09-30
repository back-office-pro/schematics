# frozen_string_literal: true

Rails.configuration.to_prepare do
  Schematics::Licence
    .instance
    .load(**Schematics::Licences::Stripe::Retrieve.call.to_h)
end
