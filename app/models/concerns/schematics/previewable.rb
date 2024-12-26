# frozen_string_literal: true

module Schematics
  module Previewable
    extend ActiveSupport::Concern

    included do
      after_save_commit :generate_link_previews
    end

    def changed_link_preview_urls = self
      .class
      .entity
      .url_attributes
      .map(&:name)
      .select { public_send(:"#{it}_previously_changed?") }
      .filter_map(&method(:public_send))

    protected

    def generate_link_previews = ::ActiveJob.perform_all_later(
      changed_link_preview_urls.map(&GenerateLinkPreviewJob.method(:new))
    )
  end
end
