# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebhookEndpoint do
  include Schematics::Specs::Model

  its(:uri) { is_expected.to be_a(URI) }
end
