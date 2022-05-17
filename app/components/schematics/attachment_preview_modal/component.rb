# frozen_string_literal: true

module Schematics
  module AttachmentPreviewModal
    class Component < ApplicationComponent
      delegate :filename, to: :@attachment

      def initialize(attachment:, icon:)
        super
        @attachment = attachment
        @icon = icon
      end

      def label = "#{target}-label"

      def target = "attachment-preview-modal-#{@attachment.id}"
    end
  end
end
