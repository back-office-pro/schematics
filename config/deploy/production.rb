# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

server ENV.fetch('HOST', 'back-office.pro'), user: 'deploy', roles: %w[deploy], port: 9876
