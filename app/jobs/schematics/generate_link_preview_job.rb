# frozen_string_literal: true

module Schematics
  class GenerateLinkPreviewJob < ApplicationJob
    retry_on OpenURI::HTTPError, wait: :polynomially_longer, attempts: 5

    def perform(url)
      LinkPreviews::Create.call(url:)
    end
  end
end
