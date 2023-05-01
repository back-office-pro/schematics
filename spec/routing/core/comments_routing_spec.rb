# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, except: :update do
  include Schematics::Specs::Routing
end
