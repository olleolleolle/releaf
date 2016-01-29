require 'axlsx_rails'
require 'twitter_cldr'
require 'i18n'

module Releaf::I18nDatabase
  require 'releaf/i18n_database/builders_autoload'
  require 'releaf/i18n_database/configuration'
  require 'releaf/i18n_database/engine'
  require 'releaf/i18n_database/humanize_missing_translations'
  require 'releaf/i18n_database/backend'

  class Engine < ::Rails::Engine
    initializer 'precompile', group: :all do |app|
      app.config.assets.precompile += %w(releaf/controllers/releaf/i18n_database/*)
    end
  end

  def self.components
    [Releaf::I18nDatabase::Configuration, Releaf::I18nDatabase::Backend, Releaf::I18nDatabase::HumanizeMissingTranslations]
  end
end
