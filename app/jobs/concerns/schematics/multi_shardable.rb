# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module MultiShardable
    extend ActiveSupport::Concern

    def for_each_shards(&)
      shards.each do |shard|
        ActiveRecord::Base.connected_to(shard:, &)
      end
    end

    private

    def shards
      return %i[default] if Rails.env.test?

      Rails
        .root
        .glob('storage/*')
        .map(&:basename)
        .map(&:to_s)
        .map(&:to_sym)
    end
  end
end
