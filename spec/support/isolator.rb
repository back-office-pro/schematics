# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'isolator'

ActiveSupport.on_load(:active_job) do
  Isolator.adapters.active_job.disable!
end
ActiveSupport.on_load(:action_cable) do
  Isolator.adapters.action_cable.disable!
end
