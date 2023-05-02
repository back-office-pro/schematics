# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::CommentsController, except: :create do
  include Schematics::Specs::Request
end
