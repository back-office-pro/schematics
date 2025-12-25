# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

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
