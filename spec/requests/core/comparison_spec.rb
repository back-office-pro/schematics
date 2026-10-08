# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comparison, except: :create do
  include Schematics::Specs::Request
end
