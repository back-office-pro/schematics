# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Shardable
    extend ActiveSupport::Concern

    included do
      around_perform do |job, block|
        ActiveRecord::Base.connected_to(shard: job.arguments.first.to_sym) { block.call }
      end
    end
  end
end
