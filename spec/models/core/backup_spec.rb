# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Backup do
  include Schematics::Specs::Model

  it 'enqueues a restore database job after restore' do
    expect { record.restore_database! }
      .to have_enqueued_job(Schematics::RestoreDatabaseJob)
      .exactly(:once)
      .with(record)
      .on_queue('backups')
      .at(:no_wait)
  end
end
