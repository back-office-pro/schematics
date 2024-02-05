# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionsController, except: :trigger do
  include Schematics::Specs::Request
end
