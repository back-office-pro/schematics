# frozen_string_literal: true

Rails.configuration.middleware.use OliveBranch::Middleware, inflection_header: 'x-api-inflection'
