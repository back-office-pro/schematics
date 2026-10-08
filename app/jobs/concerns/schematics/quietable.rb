# frozen_string_literal: true

module Schematics
  module Quietable
    extend ActiveSupport::Concern

    included do
      around_perform do |_job, block|
        PaperTrail.request(enabled: false) { block.call }
      end
    end
  end
end
