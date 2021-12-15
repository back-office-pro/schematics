# frozen_string_literal: true

module Schematics
  module Versionable
    extend ActiveSupport::Concern

    DENYLIST = %i[id created_at updated_at deleted_at lock_version slug].freeze

    included do
      has_paper_trail ignore: DENYLIST + filter_attributes,
                      versions: { class_name: 'Schematics::Version' }
    end
  end
end
