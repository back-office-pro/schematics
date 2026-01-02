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

RSpec.describe Core::Imports::ImportData do
  include_context 'with import'

  describe '.call' do
    subject(:call) { described_class.call(import:) }

    context 'with a CSV file' do
      it { is_expected.to be_a_success }
      its('import.progress') { is_expected.to eq(100) }

      it 'inserts two resources' do
        expect { call }.to change(import.model_class, :count).by(2)
      end

      it 'inserts two versions' do
        expect { call }.to change(Schematics::Version, :count).by(2)
      end
    end

    context 'with JSON data' do
      let(:file) { nil }
      let(:resources) do
        [
          {
            email: 'john.doe@somewhere.com',
            first_name: 'John',
            last_name: 'Doe',
            password: Schematics::Attributes::Digest::DEFAULT,
            locale: 'en',
            role_id: role.id,
            time_zone: 'UTC'
          },
          {
            email: 'jane.doe@somewhere.com',
            first_name: 'Jane',
            last_name: 'Doe',
            password: Schematics::Attributes::Digest::DEFAULT,
            locale: 'fr',
            role_id: role.id,
            time_zone: 'Paris'
          }
        ]
      end

      it { is_expected.to be_a_success }
      its('import.progress') { is_expected.to eq(100) }

      it 'inserts two resources' do
        expect { call }.to change(import.model_class, :count).by(2)
      end

      it 'inserts two versions' do
        expect { call }.to change(Schematics::Version, :count).by(2)
      end
    end
  end
end
