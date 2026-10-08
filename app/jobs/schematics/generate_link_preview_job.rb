# frozen_string_literal: true

module Schematics
  class GenerateLinkPreviewJob < ApplicationJob
    include Quietable

    queue_as :low

    retry_on OpenURI::HTTPError, wait: :polynomially_longer, attempts: 5

    def perform(url)
      Core::LinkPreviews::Process.call(url:)
    end
  end
end
