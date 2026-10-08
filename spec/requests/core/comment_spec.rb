# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, except: :create do
  include Schematics::Specs::Request
end
