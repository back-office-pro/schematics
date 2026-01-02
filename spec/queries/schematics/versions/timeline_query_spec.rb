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

RSpec.describe Schematics::Versions::TimelineQuery do
  subject(:query) { described_class }

  include_context 'with user'
  include_context 'with admin role'

  let(:ability) { Schematics::Ability.new(user) }
  let(:first_version) { Schematics::Version.create!(event: 'create', item: user, user:) }
  let(:second_version) { Schematics::Version.create!(event: 'update', item: user, user:) }

  before { [first_version, second_version] }

  describe '.call' do
    subject { query.call(ability, versions) }

    context 'when timeline is global without permissions and preferences' do
      let(:versions) { nil }

      it { is_expected.to be_empty }
    end

    context 'when timeline is global with permissions but without preferences' do
      let(:versions) { nil }
      let(:role) { admin_role }

      it { is_expected.to eq([second_version, first_version]) }
    end

    context 'when timeline is global with permissions and preferences' do
      let(:versions) { nil }
      let(:role) { admin_role }
      let(:preferences) { { 'create_User' => false } }

      it { is_expected.to eq([second_version]) }
    end

    context 'when timeline is local without permissions and preferences' do
      let(:versions) { user.paper_trail_versions }

      it { is_expected.to eq([second_version, first_version]) }
    end

    context 'when timeline is local with permissions but without preferences' do
      let(:versions) { user.paper_trail_versions }
      let(:role) { admin_role }

      it { is_expected.to eq([second_version, first_version]) }
    end

    context 'when timeline is local with permissions and preferences' do
      let(:versions) { user.paper_trail_versions }
      let(:role) { admin_role }
      let(:preferences) { { 'create_User' => false } }

      it { is_expected.to eq([second_version, first_version]) }
    end
  end
end
