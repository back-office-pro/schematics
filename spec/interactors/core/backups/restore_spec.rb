# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::Backups::Restore do
  include_context 'with user'

  let(:backup) { Core::Backups::Create.call.file }
  let(:clean) { true }

  around do |example|
    ActiveRecord::Base.connected_to(shard: :demo) { example.run }
  end

  describe '.call' do
    subject(:call) { described_class.call(backup:, clean:) }

    before { [user, backup, user.really_destroy!, call] }

    after { [User, Role, Team].each(&:delete_all) }

    uses_transaction 'restores the user'

    it 'restores the user' do
      expect { user.reload }.not_to raise_error
    end
  end
end
