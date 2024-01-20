# frozen_string_literal: true

module Schematics
  class ResourceMailerPreview < ActionMailer::Preview
    def forward_resource
      ResourceMailer.forward(::User.first, ::User.first, ::User.first)
    end

    def forward_resources
      ResourceMailer.forward(::User.first, ::User.first, [::User.first])
    end
  end
end
