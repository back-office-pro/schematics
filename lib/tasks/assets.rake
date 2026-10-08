# frozen_string_literal: true

ASSETS_PATH = Rails.public_path.join('assets').freeze
DIRECTORIES_PATH = ASSETS_PATH.join('**/').freeze
CONTROLLERS_PATH = ASSETS_PATH.join('controllers', '**', '*.js').freeze
APPLICATION_JS_PATH = ASSETS_PATH.join('application-*.js').freeze

Rake::Task['assets:precompile'].enhance do
  FileUtils.rm_rf Dir.glob(DIRECTORIES_PATH.join('*.{rb,yml,ts,json,md}'))
  Dir[DIRECTORIES_PATH].reverse_each { Dir.rmdir(it) if Dir.empty?(it) }
  Dir.glob([CONTROLLERS_PATH, APPLICATION_JS_PATH]).each do |path|
    File.write(path, Terser.compile(File.read(path)))
  end
end
