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
require 'generators/permissions/permissions_generator'

RSpec.describe PermissionsGenerator do
  subject(:generator) { described_class.new([name], options, behavior:) }

  include_context 'with user'
  include_context 'with admin role'

  let(:name) { 'User' }
  let(:model) { 'User' }
  let(:behavior) { :invoke }
  let(:options) { [] }
  let(:permission) { Permission.create!(model:, action: 'create') }
  let(:chart) { Chart.create!(kind: 'line', aggregate: 'count', model:, x_field: 'User#full_name') }
  let(:metric) { Metric.create!(aggregate: 'count', model:) }
  let(:version) { Schematics::Version.create!(event: 'create', item: user, user:) }

  before { [permission, chart, metric, version] }

  describe '#invoke_all' do
    subject(:invoke_all) { generator.invoke_all }

    context 'when revoking' do
      let(:behavior) { :revoke }

      it 'destroys permissions' do
        expect { invoke_all }
          .to change(Permission.with_deleted, :count)
          .by(-7)
      end

      it 'archives charts' do
        expect { invoke_all }
          .to change(Chart, :count)
          .by(-1)
      end

      it 'archives metrics' do
        expect { invoke_all }
          .to change(Metric, :count)
          .by(-1)
      end

      it 'destroys versions' do
        expect { invoke_all }
          .to change(Schematics::Version, :count)
          .by(-1)
      end
    end

    context 'when renaming' do
      let(:name) { 'Role' }
      let(:options) { ['--rename=User'] }

      it 'updates permissions' do
        expect { invoke_all }
          .to change { permission.reload.model }
          .from('User')
          .to('Role')
      end

      it 'updates charts' do
        expect { invoke_all }
          .to change { chart.reload.model }
          .from('User')
          .to('Role')
      end

      it 'updates metrics' do
        expect { invoke_all }
          .to change { metric.reload.model }
          .from('User')
          .to('Role')
      end

      it 'updates versions' do
        expect { invoke_all }
          .to change { version.reload.item_type }
          .from('User')
          .to('Role')
      end
    end
  end
end
