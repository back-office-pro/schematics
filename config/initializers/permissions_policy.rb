# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

Rails.configuration.permissions_policy do |policy|
  policy.camera :none
  policy.gyroscope :none
  policy.microphone :none
  policy.usb :none
  policy.fullscreen :self
  policy.payment :self
end
