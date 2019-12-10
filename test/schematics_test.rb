require 'test_helper'

class Schematics::Test < ActiveSupport::TestCase
  def test_print_schema
    Schematics::SCHEMA.entities.each do |entity|
      puts "#{entity.type.camelize} (#{entity.descriptor.name})"
      puts "------------------------------------"
      puts entity.attributes
      puts "------------------------------------"
      puts entity.attributes.map(&:to_str).reject(&:empty?)
      puts "------------------------------------"
      puts entity.associations.map(&:to_str)
      puts "------------------------------------"
      puts entity.virtuals.map(&:to_str)
      puts "------------------------------------"
      puts entity.validates
      puts "------------------------------------"
      puts entity.scopes
      puts "------------------------------------"
      puts entity.has_scopes
      puts "------------------------------------"
      puts entity.api
      puts 
    end
  end
end
