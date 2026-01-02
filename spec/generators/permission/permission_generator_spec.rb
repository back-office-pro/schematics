# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'rails_helper'
require 'generators/permission/permission_generator'

RSpec.describe PermissionGenerator do
  subject(:generator) { described_class.new(['User'], options, behavior:) }

  include_context 'with admin role'

  let(:permission) { Permission.create!(model: 'User', action: 'create') }

  before { permission }

  describe '#invoke_all' do
    subject(:invoke_all) { generator.invoke_all }

    context 'when invoking' do
      let(:behavior) { :invoke }
      let(:options) { ['--action=create'] }

      it 'creates admin permission' do
        expect { invoke_all }
          .to change(admin_role.permissions, :count)
          .by(1)
      end
    end

    context 'when revoking' do
      let(:behavior) { :revoke }
      let(:options) { ['--action=create'] }

      it 'destroys permission' do
        expect { invoke_all }
          .to change(Permission.with_deleted, :count)
          .by(-2)
      end
    end

    context 'when renaming' do
      let(:behavior) { :invoke }
      let(:options) { ['--action=show', '--rename=create'] }

      it 'updates permission' do
        expect { invoke_all }
          .to change { permission.reload.action }
          .from('create')
          .to('show')
      end
    end
  end
end
