# frozen_string_literal: true

class Import < Schematics::ApplicationRecord
  after_create_commit { Schematics::ImportJob.perform_later(self) }

  def model_class
    model.safe_constantize
  end

  def finalize!(import_errors)
    return update!(state: 'error', import_errors:) if import_errors

    state_finished!
    model_class.try(:reindex)
  end
end
