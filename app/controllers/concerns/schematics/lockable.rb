# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Lockable
    extend ActiveSupport::Concern

    def assign_etag
      response.headers['ETag'] = @resource.lock_version
    end

    private

    def lock_version_from_if_match_header = request
      .headers['If-Match']
      .to_i
  end
end
