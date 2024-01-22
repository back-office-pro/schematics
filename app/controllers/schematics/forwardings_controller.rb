# frozen_string_literal: true

module Schematics
  class ForwardingsController < ApplicationController
    include Nestable
    before_action -> { authorize!(:show, record) }

    def create
      result = Forwardings::Create.call(record:, recipients:, sender: current_user)
      respond_with result, location: index_path
    end

    private

    def recipients
      ::User.find(params.require(:recipients))
    end

    def index_path
      main_app.polymorphic_path(record)
    end

    alias human_name parent_human_name

    alias gender parent_gender

    def flash_interpolation_options = { human_name:, gender: }
  end
end
