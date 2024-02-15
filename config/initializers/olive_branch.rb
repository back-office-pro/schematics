# frozen_string_literal: true

require 'olive_branch'

Rails.configuration.middleware.use OliveBranch::Middleware, inflection_header: 'x-api-inflection'
