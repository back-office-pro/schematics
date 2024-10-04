# frozen_string_literal: true

module Schematics
  module Previewable
    extend ActiveSupport::Concern

    included do
      after_save_commit :generate_link_previews, if: :link_preview_urls?
    end

    def link_preview_urls = self
      .class
      .entity
      .url_attributes
      .map(&:name)
      .filter_map(&method(:public_send))

    protected

    def link_preview_urls?
      link_preview_urls.any?
    end

    def generate_link_previews = ::ActiveJob.perform_all_later(
      link_preview_urls.map(&GenerateLinkPreviewJob.method(:new))
    )
  end
end
