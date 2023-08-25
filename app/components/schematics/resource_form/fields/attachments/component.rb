# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module Attachments
        class Component < Attachment::Component
          def signed_ids = value.map(&:signed_id)
        end
      end
    end
  end
end
