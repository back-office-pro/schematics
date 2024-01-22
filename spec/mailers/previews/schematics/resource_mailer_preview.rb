# frozen_string_literal: true

module Schematics
  class ResourceMailerPreview < ActionMailer::Preview
    def forward
      ResourceMailer.forward(::User.first, ::User.first, ::User.first)
    end
  end
end
