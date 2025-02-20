# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

namespace :schematics do
  namespace :subscription do
    desc 'Load subscription from gateway'
    task load: :environment do
      Subscription.instance.load!
    end
  end
end
