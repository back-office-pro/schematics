# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

namespace :schematics do
  namespace :subscription do
    desc 'Load subscription from gateway'
    task load: :environment do
      Schematics::LoadSubscriptionJob.perform_now ENV.fetch('DATABASE')
    end
  end
end
