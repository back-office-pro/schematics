# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::AuthToken do
  subject { described_class.new(session) }

  include_context 'with user'

  let(:session) { Session.create!(user:) }

  its(:as_json) do
    is_expected.to match(
      token_type: 'Bearer',
      expires_in: 600,
      access_token: String,
      refresh_token: String
    )
  end
end
