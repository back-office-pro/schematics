# frozen_string_literal: true

module Schematics
  class LoadSubscriptionJob < ApplicationJob
    def perform = ::Subscription
      .instance
      .load!
  end
end
