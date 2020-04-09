class RoutesGenerator < Rails::Generators::Base
  def inject_localized_block
    inject_into_file "config/routes.rb", before: "end" do
      indent <<~RUBY
        localized do
        end
      RUBY
    end
  end
end
