module I18n
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
      array = []
      locales.each_with_index do |loc, n|
        loc.each_with_index do |row, i|
          array[i] ||= []
          array[i][0] = row[0]
          array[i][n+1] = row[1]
        end
      end
      array
    end

    def self.pack(hash, scope = nil)
      array = []
      hash.each do |key, value|
        if value.is_a?(Hash)
          array += build(value, key)
        elsif scope
          array << [[scope, key].join(SCOPE_SEPERATOR), value]
        else
          array << [key, value]
        end
      end
      array
    end
  end
end
