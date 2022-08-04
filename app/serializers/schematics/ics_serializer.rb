# frozen_string_literal: true

module Schematics
  class IcsSerializer
    delegate :class, to: :@resource, prefix: :model, private: true
    delegate :human_name, to: :model_class, private: true

    def initialize(resource)
      @resource = resource
    end

    def content_type = ::Mime[extension].to_s

    def extension = :ics

    def file = calendar.to_ical

    def filename = "#{human_name.dasherize}-#{@resource.slug}.#{extension}"

    private

    def calendar
      @calendar ||= begin
        calendar = Icalendar::Calendar.new
        calendar.event do |event|
          event.dtstart = Icalendar::Values::Date.new(@resource.try(:start_at) || ::Time.current)
          event.dtend = Icalendar::Values::Date.new(@resource.try(:end_at) || ::Time.current)
          event.summary = @resource.try(:subject)
          event.description = @resource.try(:content).try(&:to_plain_text)
          event.url = @resource.try(:url)
          event.location = @resource.try(:location)
        end
        calendar
      end
    end
  end
end
