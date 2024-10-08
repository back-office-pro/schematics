# frozen_string_literal: true

SolidQueue.on_start { RoutesLazyRoutes.eager_load! } # TODO: remove when upgrading to Rails 8
