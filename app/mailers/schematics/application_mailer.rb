# frozen_string_literal: true

module Schematics
  class ApplicationMailer < ::ApplicationMailer
    layout 'schematics/mailer'
    helper ApplicationHelper
  end
end
