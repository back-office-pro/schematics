# frozen_string_literal: true

module Schematics
  class ApplicationMailer < ActionMailer::Base
    layout 'schematics/mailer'
    helper ApplicationHelper
  end
end
