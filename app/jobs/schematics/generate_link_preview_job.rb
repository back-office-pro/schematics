# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class GenerateLinkPreviewJob < ApplicationJob
    include Shardable
    include Quietable
    queue_as :low

    retry_on OpenURI::HTTPError, wait: :polynomially_longer, attempts: 5

    def perform(_shard, url)
      Core::LinkPreviews::Process.call(url:)
    end
  end
end
