# frozen_string_literal: true

module Schematics
  module Licensable
    extend ActiveSupport::Concern

    included do
      before_create :authorize_create!
      before_restore :authorize_restore!
    end

    private

    def authorize_create!
      throw :abort if ability.cannot?(:create, self)
    end

    def authorize_restore!
      throw :abort if ability.cannot?(:restore, self)
    end

    def ability
      @ability ||= RecordAbility.new.merge(LicenseAbility.new)
    end
  end
end
