# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Backup do
  include Schematics::Specs::Model

  it 'enqueues a restore backup job after restore database' do
    expect { record.restore_database! }
      .to have_enqueued_job(Schematics::RestoreBackupJob)
      .exactly(:once)
      .with(:default, record.id)
      .on_queue('critical')
      .at(:no_wait)
  end
end
