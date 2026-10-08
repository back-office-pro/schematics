# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::Messages::UnreadQuery do
  include_context 'with user'

  let(:version) { Schematics::Version.create!(event: 'show', item: message, user:) }
  let(:message) do
    Message.create!(subject: 'Foo', content: 'Lorem', author: user, recipients: [user])
  end

  before { message }

  context 'when message is not read' do
    its(:call) { is_expected.to contain_exactly(message) }
  end

  context 'when message is read' do
    before { version }

    its(:call) { is_expected.to be_empty }
  end
end
