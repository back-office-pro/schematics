# frozen_string_literal: true

module Schematics
  module Versionable
    extend ActiveSupport::Concern

    included do
      has_paper_trail ignore: %i[id created_at updated_at deleted_at read_at slug],
                      versions: { class_name: 'Schematics::Version' }
    end
  end
end
