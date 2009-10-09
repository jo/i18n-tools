require File.dirname(__FILE__) + '/../init'
require 'csv'

namespace :i18n do
  namespace :convert do
    desc "Convert i18n yml files to single csv"
    task :csv do
      files = Dir.glob(File.join(RAILS_ROOT, 'config/locales/*.yml'))
      if files.empty?
        puts 'no config/locales/*.yml!'
      end
      hash = {}
      files.each do |filename|
        hash.update YAML.load(File.read(filename))
      end

      array = I18nTools::Arrayer.load(hash)
      array.each { |line| puts CSV.generate_line line, ';' }
    end

    namespace :yml do
      Dir.glob(File.join(RAILS_ROOT, 'config/locales/*.yml')).each do |file|
        locale = File.basename(file).sub(/\.yml$/, '')
        desc "Convert i18n csv file to #{locale} yml"
        task locale do
          filename = File.join(RAILS_ROOT, 'config/locales/translations.csv')
          unless File.exists?(filename)
            puts 'no config/locales/translations.csv!'
          end
          array = []
          CSV.open(filename, 'r', ";").each do |row|
            array << row
          end
          # only show current
          hash = { locale => I18nTools::Hasher.load(array)[locale] }
          yamler = I18nTools::Yamler.new(hash)
          yamler.puts
        end
      end
    end
  end
end
