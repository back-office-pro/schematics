# frozen_string_literal: true

module Schematics
  module SoftDeletable
    extend ActiveSupport::Concern

    included do
      acts_as_paranoid
      scope :search_import, -> { preload(entity.includes).with_deleted }
    end
  end
end
