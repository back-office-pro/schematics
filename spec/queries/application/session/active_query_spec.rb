# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application::Session::ActiveQuery do
  include_context 'with user'

  let(:first_session) { Session.create!(user:) }
  let(:second_session) do
    Session.create!(user:, updated_at: Time.current - Application::Session::ACTIVE_DELAY)
  end

  before { [first_session, second_session] }

  its(:call) { is_expected.to contain_exactly(first_session) }
end
