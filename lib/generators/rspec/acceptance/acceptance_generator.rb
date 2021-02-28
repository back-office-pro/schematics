module Rspec
  class AcceptanceGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('templates', __dir__)

    def generate_acceptance_spec
      template 'acceptance.rb.tt', spec_file_path
    end

    private

    def spec_file_path
      File.join('spec', 'acceptance', "#{name.pluralize}_spec.rb")
    end
  end
end
