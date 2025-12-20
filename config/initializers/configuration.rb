# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: false

Rails.configuration.after_initialize do
  suppress(StandardError) do
    Configuration.instance.update_storage_services!
  end
end
