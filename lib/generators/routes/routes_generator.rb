class RoutesGenerator < Rails::Generators::Base
  def add_routes
    inject_into_file "config/routes.rb", before: "end" do
      indent <<~RUBY
        localized do
          Schematics::SCHEMA.load_routes
        end
      RUBY
    end
  end
end
