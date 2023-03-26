# frozen_string_literal: true

server ENV.fetch('DEPLOY_HOST', 'back-office.pro'), user: 'deploy', roles: %w[deploy], port: 9876
