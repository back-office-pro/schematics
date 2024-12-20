# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::Backups::Restore do
  include_context 'with user'

  let(:backup) { Core::Backups::Create.call.file }
  let(:clean) { true }

  describe '.call' do
    subject(:call) { described_class.call(backup:, clean:) }

    before do
      [user, backup, user.really_destroy!]
    end

    it 'restores the user', skip: 'to be fixed' do
      expect { call }
        .to change(User, :count)
        .from(0)
        .to(1)
    end
  end
end
