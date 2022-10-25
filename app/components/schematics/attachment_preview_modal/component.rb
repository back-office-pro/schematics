# frozen_string_literal: true

module Schematics
  module AttachmentPreviewModal
    class Component < ApplicationComponent
      delegate :filename, to: :attachment
      option :attachment
      option :icon

      def label = "#{target}-label"

      def target = "attachment-preview-modal-#{attachment.id}"
    end
  end
end
