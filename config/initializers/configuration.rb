# frozen_string_literal: false

Rails.configuration.after_initialize do
  suppress(StandardError) do
    Configuration.instance.update_storage_services!
    Configuration.instance.update_mailer_settings!
    Rails.configuration.hosts << Configuration.host if Rails.env.production?
  end
end
