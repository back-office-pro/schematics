# frozen_string_literal: true

Rails.configuration.after_initialize do
  Pagy::OPTIONS[:client_limit] = 100
  Pagy.translate_with_the_slower_i18n_gem!
  Pagy::Calendar.localize_with_rails_i18n_gem(*Rails.configuration.i18n.available_locales)
end
