# frozen_string_literal: true

require 'rails_helper'
require 'generators/permissions/permissions_generator'

RSpec.describe PermissionsGenerator do
  subject(:generator) { described_class.new([name], options, behavior:) }

  include_context 'with user'

  let(:name) { 'user' }
  let(:model) { 'User' }
  let(:behavior) { :invoke }
  let(:options) { [] }
  let(:permission) { Permission.create!(model:, action: 'create') }
  let(:chart) { Chart.create!(kind: 'line', agregate: 'count', model:, x_field: 'User#full_name') }
  let(:stat) { Stat.create!(agregate: 'count', model:) }
  let(:version) { Schematics::Version.create!(event: 'create', item: user, user:) }
  let(:admin_role) { Role.create!(name: 'Admin') }

  before { [permission, chart, stat, version, admin_role] }

  describe '#invoke_all' do
    subject(:invoke_all) { generator.invoke_all }

    context 'when invoking' do
      it 'creates admin permissions' do
        expect { invoke_all }
          .to change(admin_role.permissions, :count)
          .by(6)
      end
    end

    context 'when revoking' do
      let(:behavior) { :revoke }

      it 'destroys permissions' do
        expect { invoke_all }
          .to change(Permission, :count)
          .by(-1)
      end

      it 'destroys charts' do
        expect { invoke_all }
          .to change(Chart, :count)
          .by(-1)
      end

      it 'destroys stats' do
        expect { invoke_all }
          .to change(Stat, :count)
          .by(-1)
      end

      it 'destroys versions' do
        expect { invoke_all }
          .to change(Schematics::Version, :count)
          .by(-1)
      end
    end

    context 'when reinvoking' do
      let(:name) { 'role' }
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

      it 'updates stats' do
        expect { invoke_all }
          .to change { stat.reload.model }
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
