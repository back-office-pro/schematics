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

RSpec.describe Permission do
  include Schematics::Specs::Model
  include Schematics::ResourcesHelper

  its(:model_class) { is_expected.to eq(User) }
  its(:webhook_event) { is_expected.to start_with('user.') }
  its(:webhook_url) { is_expected.to eq(resources_url(User, host: 'localhost', port: 3000)) }

  describe '.create_entities_permissions!' do
    subject(:create_entities_permissions!) do
      described_class.create_entities_permissions!
    end

    it 'creates all entities permissions' do
      expect { create_entities_permissions! }
        .to change(described_class, :count)
        .by(123)
    end
  end
end
