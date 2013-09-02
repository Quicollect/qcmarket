require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'net/http'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module QCMarket
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    config.autoload_paths += Dir[Rails.root.join('app', 'models', '{**}')]

    config.assets.precompile += ['footer.js', 'gt-ie8.js', 'ie.js', 'lt-ie9.js', 'gt-ie8.css', 'ie7.css']

    config.cache_store = :file_store, 'tmp/cache/data'

<<<<<<< HEAD
    config.generators do |g|
        g.test_framework :rspec
    end

=======
>>>>>>> e74b7e8... first commit to the market place app
    # Load application ENV vars and merge with existing ENV vars. Loaded here so can use values in initializers.
    yaml = YAML.load_file('config/application.yml')
    ENV.update(yaml["all"]) rescue {}
    ENV.update(yaml[Rails.env]) rescue {}

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
<<<<<<< HEAD
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
=======
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
>>>>>>> e74b7e8... first commit to the market place app
    # config.i18n.default_locale = :de
    end
end
