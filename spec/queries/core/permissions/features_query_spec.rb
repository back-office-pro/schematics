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

RSpec.describe Core::Permissions::FeaturesQuery do
  let(:permissions) { Permission.create_entities_permissions! }
  let(:expected_permissions) do
    [
      Permission.where(model: 'Import').to_a,
      Permission.where(model: 'Message').to_a,
      Permission.where(model: 'Comment').to_a,
      Permission.where(model: 'Meeting').to_a,
      Permission.where(model: 'Task').to_a,
      Permission.where(model: 'Chart', action: 'show'),
      Permission.where(model: 'Metric', action: 'show'),
      Permission.where(model: 'Ranking', action: 'show'),
      Permission.where(model: 'ActiveStorage::Blob', action: 'index')
    ].flatten
  end

  before { permissions }

  its(:call) { is_expected.to match_array(expected_permissions) }
end
