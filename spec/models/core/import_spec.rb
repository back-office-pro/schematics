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

RSpec.describe Import do
  include Schematics::Specs::Model

  its(:locale) { is_expected.to eq('en') }
  its(:model_class) { is_expected.to eq(User) }
  its(:import_errors) { is_expected.to be_empty }

  it 'enqueues an import job after create' do
    expect { record.save! }
      .to have_enqueued_job(Schematics::ImportJob)
      .exactly(:once)
      .with(record)
      .on_queue('default')
      .at(:no_wait)
  end

  describe '#finalize!' do
    subject(:finalize!) { record.finalize!(errors) }

    context 'when there is no import error' do
      let(:errors) { nil }

      it 'changes import state from pending to finished' do
        expect { finalize! }
          .to change(record, :state)
          .from('pending')
          .to('finished')
      end
    end

    context 'when there are import errors' do
      let(:errors) { { 1 => 'Name already taken' } }

      it 'changes import state from pending to error' do
        expect { finalize! }
          .to change(record, :state)
          .from('pending')
          .to('error')
      end

      it 'stores import errors' do
        expect { finalize! }
          .to change(record, :import_errors)
          .from({})
          .to('Line 1' => 'Name already taken')
      end
    end
  end
end
