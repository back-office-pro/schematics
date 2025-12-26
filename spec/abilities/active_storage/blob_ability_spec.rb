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
require 'cancan/matchers'

RSpec.describe ActiveStorage::BlobAbility do
  subject(:ability) { described_class.new }

  it { is_expected.not_to be_able_to(:read, ActiveStorage::Blob, filename: 'db.dump') }
  it { is_expected.not_to be_able_to(:read, ActiveStorage::Blob, filename: 'license.json') }
  it { is_expected.not_to be_able_to(:read, ActiveStorage::Blob, attachments: { name: 'preview_image' }) } # rubocop:disable Layout/LineLength
  it { is_expected.not_to be_able_to(:read, ActiveStorage::Blob, attachments: { record_type: 'Backup' }) } # rubocop:disable Layout/LineLength
  it { is_expected.not_to be_able_to(:read, ActiveStorage::Blob, attachments: { record_type: 'LinkPreview' }) } # rubocop:disable Layout/LineLength
end
