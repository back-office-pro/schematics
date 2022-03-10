# frozen_string_literal: true

module MainApp
  module Message
    extend ActiveSupport::Concern

    prepended do
      scope :unread, lambda {
        where(
          'NOT EXISTS (:version)',
          version: Schematics::Version.where(
            <<~SQL.squish
              versions.item_type = 'Message' AND
              versions.item_id = messages.id AND
              versions.event = 'show'
            SQL
          )
        )
      }
    end
  end
end
