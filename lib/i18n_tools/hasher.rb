require 'activesupport' # for deep_merge

module I18nTools
  # builds hashes from arrays of i18n locale translations.
  module Hasher
    # builds a i18n Hash from Array.
    # the first entry of the array should contain the headers.
    # Eg: [:key, :de, :en]
    # Keys are namespaced by '.'
    # Eg: tools.button
    # This leads to nested hashes.
    def self.load(array = [])
      return {} if array.empty?
      # first row is header
      locales = array.shift
      # remove first header entry, should be :key or whatever
      locales.shift
      raise 'No locales given!' if locales.empty?
      hash = {}
      locales.each_with_index do |locale, i|
        ary = array.map { |e| [e.first, e[i+1]] }
        hash[locale.to_s] = build(ary)
      end
      hash
    end

    private

    # iterates over the array,
    # builds nested hashes for each scoped key
    # and returns a hash with all those keys
    def self.build(array)
      raise "Could not parse: %s" % array.inspect unless array.all? { |a| a.size == 2 }
      hash = {}
      array.each do |row|
        key, value = row
        hash.deep_merge! unpack(key.to_s, value.to_s)
      end
      hash
    end

    ARRAY_EXP = /\A\[(.*)\]\z/
    # takes care of scopes.
    # eg.
    # unpack('a', 'b') #=> { 'a' => 'b' }
    # unpack('a.b', 'c') #=> { 'a' => { 'b' => 'c' } }
    def self.unpack(key, value)
      if value =~ ARRAY_EXP
        value = value.gsub(ARRAY_EXP, '\1').split(/,\s*/)
      end
      if key.include?(SCOPE_SEPERATOR)
        keys = key.split(SCOPE_SEPERATOR)
        key = keys.shift
        { key => unpack(keys.join(SCOPE_SEPERATOR), value) }
      else
        { key => value }
      end
    end
  end
end
