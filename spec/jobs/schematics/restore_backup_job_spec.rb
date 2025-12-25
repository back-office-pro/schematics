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

require 'rails_helper'

RSpec.describe Schematics::RestoreBackupJob do
  let(:backup) { Backup.create!(file:, state:) }
  let(:state) { Backup::STATE_STATE_RESTORING }
  let(:file) { Core::Backups::Create.call.file }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(backup) }
        .to have_enqueued_job(described_class)
        .exactly(:once)
        .on_queue('critical')
        .at(:no_wait)
    end
  end

  describe '#perform_now' do
    subject(:perform_now) { described_class.perform_now(backup) }

    it 'restores the database backup' do
      expect { perform_now }.not_to change(backup, :state)
    end

    context 'when there is a file not found error' do
      before do
        allow(ActiveRecord::Base.connection_pool)
          .to receive(:disconnect!)
          .and_return(nil)
        allow(file)
          .to receive(:open)
          .and_raise(ActiveStorage::FileNotFoundError)
      end

      it 'changes backup state from restoring to error after discard' do
        expect { perform_now }
          .to change(backup, :state)
          .from(Backup::STATE_STATE_RESTORING.to_s)
          .to(Backup::STATE_STATE_ERROR.to_s)
      end
    end
  end
end
