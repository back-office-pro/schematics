module Schematics
  class ApplicationMailer < ActionMailer::Base
    layout 'schematics/mailer'
    helper ApplicationHelper
  end
end
