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
  let(:permission) { Core::Permission.create!(model:, action: 'create') }
  let(:stat) { Core::Stat.create!(agregate: 'count', model:) }
  let(:version) { Schematics::Version.create!(event: 'create', item: user, user:) }
  let(:admin_role) do
    Core::Role.create!(
      name: 'Admin',
      permissions: Core::Permission.create_entities_permissions!,
      created_at: Time.current.yesterday
    )
  end

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
          .to change(Core::Permission, :count)
          .by(-7)
      end

      it 'destroys charts' do
        expect { invoke_all }
          .to change(Core::Chart, :count)
          .by(-1)
      end

      it 'destroys stats' do
        expect { invoke_all }
          .to change(Core::Stat, :count)
          .by(-1)
      end

      it 'destroys versions' do
        expect { invoke_all }
          .to change(Schematics::Version, :count)
          .by(-1)
      end
    end

    context 'when renaming' do
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
