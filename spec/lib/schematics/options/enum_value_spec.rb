# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

describe Schematics::Options::EnumValue do
  subject { described_class.new(enum:, value: 'completed') }

  let(:entity) { Schematics::Entities::Entity.new(name: 'task') }
  let(:enum) { Schematics::Attributes::Enum.new(entity:, name: 'state') }

  it { is_expected.to be_a(Schematics::Behaviours::Internationalizable) }
  it { is_expected.to be_valid }

  its(:name) { is_expected.to eq('state') }
  its(:id) { is_expected.to eq('activerecord.enums.task.state.completed') }
  its(:i18n_scope) { is_expected.to eq(:enums) }
  its(:i18n_key) { is_expected.to eq('activerecord.enums.task.state.completed') }
end
