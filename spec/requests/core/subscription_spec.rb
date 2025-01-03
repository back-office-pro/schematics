# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subscription, except: :trigger do
  include Schematics::Specs::Request
end
