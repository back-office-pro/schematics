# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::EmailTemplateAbility do
  subject(:ability) { described_class.new }

  it { is_expected.not_to be_able_to(:duplicate, EmailTemplate) }
end
