# frozen_string_literal: true

module Schematics
  module SoftDeletable
    extend ActiveSupport::Concern

    included do
      acts_as_paranoid delete_all_enabled: true
    end
  end
end
