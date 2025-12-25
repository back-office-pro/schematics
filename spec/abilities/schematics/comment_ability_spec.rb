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

RSpec.describe Schematics::CommentAbility do
  subject(:ability) { described_class.new(user) }

  let(:user) { User.new }
  let(:comment) { Comment.new(author:) }

  it { is_expected.to be_able_to(:comment, :all) }
  it { is_expected.not_to be_able_to(:comment, Comment) }
  it { is_expected.not_to be_able_to(:import, Comment) }
  it { is_expected.not_to be_able_to(:duplicate, Comment) }

  context 'when the user is not the author' do
    let(:author) { nil }

    it { is_expected.not_to be_able_to(:update, comment) }
    it { is_expected.not_to be_able_to(:destroy, comment) }
    it { is_expected.not_to be_able_to(:archive, comment) }
  end

  context 'when the user is the author' do
    let(:author) { user }

    it { is_expected.to be_able_to(:update, comment) }
    it { is_expected.to be_able_to(:destroy, comment) }
    it { is_expected.to be_able_to(:archive, comment) }
  end
end
