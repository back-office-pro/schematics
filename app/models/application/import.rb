# frozen_string_literal: true

module Application
  module Import
    extend ActiveSupport::Concern

    prepended do
      after_create { Schematics::ImportJob.perform_later(self) }
    end

    def model_class
      model.safe_constantize
    end
  end
end
