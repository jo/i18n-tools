module I18nTools
  class Yamler
    def initialize(hash)
      @hash = hash
      @indent = 0
    end
  
    def puts
      @output = STDOUT
      output_hash
    end
  
    def putcsv
      @output = STDOUT
      output_hash_as_csv
    end
  
    def write(filename)
      `mv #{filename} #{filename}.bak` if File.exists?(filename)
      @output = File.open(filename, 'w')
      output_hash
      @output.close
    end
  
    private
  
    def output_hash
      @hash.keys.sort.each { |k| output_pair k, @hash[k] }
      line_break
    end
  
    def output_hash_as_csv
      @hash.keys.sort.each { |k| output_pair_as_csv k, @hash[k] }
      line_break
    end
  
    def output_pair(key, value)
      line_break
      put '%s: ' % key
      case value
      when Hash
        @indent += 2
        value.keys.sort.each { |k| output_pair k, value[k] }
        @indent -= 2
      when String
        print '"%s"' % value.gsub('"', '\"')
      when Integer
        print value
      when Float
        print value
      when nil
        print '~'
      when Array
        print '[%s]' % value.map { |v| v.nil? ? '~' : v }.join(', ')
      else
        raise value.inspect
      end
    end
  
    def output_pair_as_csv(key, value)
      case value
      when Hash
        value.keys.sort.each { |k| output_pair_as_csv [key, k].join('.'), value[k] }
      when Array
        line_break
        print [key, value.map { |v| v.nil? ? '~' : v }.join(', ')].join(';')
      when nil
      when Fixnum
        line_break
        print [key, value].join(';')
      else
        line_break
        print [key, '"%s"' % value.gsub('"', '\"')].join(';')
      end
    end
  
    def line_break
      @output.puts
    end
  
    def print(string)
      @output.print string
    end
    
    def put(string)
      print [' '*@indent, string.lstrip].join
    end
  end
end
