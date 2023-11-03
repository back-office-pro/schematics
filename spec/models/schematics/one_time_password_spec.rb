# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::OneTimePassword do
  subject(:one_time_password) { described_class.new(user:, attempt:) }

  include_context 'with user'

  let(:attempt) { '123456' }

  its(:secret) { is_expected.to be_a(String) }
  its(:qr_code) { is_expected.to be_a(RQRCode::QRCode) }
  its(:verify) { is_expected.to be_falsy }
end
