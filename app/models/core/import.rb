# frozen_string_literal: true

module Core
  module Import
    extend ActiveSupport::Concern

    prepended do
      after_create_commit { Schematics::ImportJob.perform_later(self) }
    end

    def model_class
      model.safe_constantize
    end
  end
end
