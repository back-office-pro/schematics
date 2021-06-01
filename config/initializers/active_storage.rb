# frozen_string_literal: true

# Make sure we override main app 6.0 defaults
Rails.application.config.active_storage.replace_on_assign_to_many = false
