# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

Rails.configuration.middleware.use OliveBranch::Middleware, inflection_header: 'x-api-inflection'
