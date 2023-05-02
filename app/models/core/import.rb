# frozen_string_literal: true

module Core
  class Import < Schematics::ApplicationRecord
    after_create_commit { Schematics::ImportJob.perform_later(self) }

    def model_class
      model.safe_constantize
    end
  end
end
