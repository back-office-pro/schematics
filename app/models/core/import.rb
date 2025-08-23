# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

# :reek:MissingSafeMethod
class ::Import < Schematics::ApplicationRecord
  delegate :locale, to: :author
  after_create_commit :perform_import_job

  validates :resources, presence: true, unless: -> { file.attached? }

  def model_class
    model.safe_constantize
  end

  def data
    return CSV.parse(file.download, headers: true, encoding: 'utf-8') if file.attached?

    resources
  end

  def import_errors
    super&.transform_keys { |line| I18n.t('line', line:) }
  end

  def finalize!(import_errors)
    return update!(state: 'error', import_errors:) if import_errors

    model_class.rebuild_search_index
    state_finished!
  end

  private

  def perform_import_job
    Schematics::ImportJob.perform_later(self)
  end
end
