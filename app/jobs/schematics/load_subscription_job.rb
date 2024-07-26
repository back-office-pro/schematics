# frozen_string_literal: true

module Schematics
  class LoadSubscriptionJob < ApplicationJob
    include Quietable

    def perform = ::Subscription
      .instance
      .load!
  end
end
