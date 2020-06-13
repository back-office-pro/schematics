module Schematics
  class ApplicationMailer < ActionMailer::Base
    layout 'schematics/mailer'
    helper ApplicationHelper
    include ::Cell::RailsExtensions::ActionController
  end
end
