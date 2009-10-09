module I18nTools
  module Arrayer
    def self.load(hash = {})
      return [] if hash.empty?
      headers = ['key']
      headers += hash.keys.sort
      [headers] + build(hash)
    end

    private

    def self.build(hash)
      locales = []
      hash.keys.sort.each do |locale|
        locales << pack(hash[locale])
      end
      merge(locales)
    end

    def self.pack(hash, array = [], scope = nil)
      hash.each do |key, value|
        key = [scope, key].compact.join(SCOPE_SEPERATOR)
        case value
        when Hash
          pack(value, array, key)
        when Array
          array << [key, '[%s]' % value.join(', ')]
        else
          array << [key, value]
        end
      end
      array
    end

    def self.merge(locales)
      array = []
      size = locales.size
      locales.each_with_index do |locale, i|
        locale.entries.each do |key_value|
          key, value = key_value
          entry = array.detect { |e| e.first == key }
          unless entry
            default =  key.sub(/^.*\./, '').gsub('_', ' ')
            entry = Array.new(size + 1, default)
            entry[0] = key
            array << entry
          end
          entry[i+1] = value
        end
      end
      array.sort! { |a, b| a.first <=> b.first }
      array
    end
  end
end
