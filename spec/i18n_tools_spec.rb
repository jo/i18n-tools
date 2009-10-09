require File.dirname(__FILE__) + "/../init.rb"

describe "I18nTools Tools" do
  it "should build empty" do
    array = []
    hash = {}
    I18nTools::Arrayer.load(hash).should == array
    I18nTools::Hasher.load(array).should == hash
  end

  it "should build empty with headers" do
    hash = {
      'de' => {},
    }
    array = [
      ['key', 'de']
    ]
    I18nTools::Arrayer.load(hash).should == array
    I18nTools::Hasher.load(array).should == hash
  end

  it "should build empty with two headers" do
    hash = {
      'de' => {},
      'en' => {},
    }
    array = [
      ['key', 'de', 'en'],
    ]
    I18nTools::Arrayer.load(hash).should == array
    I18nTools::Hasher.load(array).should == hash
  end

  it "should build simple" do
    hash = {
      'de' => { 'key' => 'value' },
    }
    array = [
      ['key', 'de'],
      ['key', 'value'],
    ]
    I18nTools::Arrayer.load(hash).should == array
    I18nTools::Hasher.load(array).should == hash
  end

  it "should build array" do
    hash = {
      'de' => { 'key' => ['value1', 'value2'] },
    }
    array = [
      ['key', 'de'],
      ['key', '[value1, value2]'],
    ]
    I18nTools::Arrayer.load(hash).should == array
    I18nTools::Hasher.load(array).should == hash
  end

  it "should build simple with two headers" do
    hash = {
      'de' => { 'key' => 'value1' },
      'en' => { 'key' => 'value2' },
    }
    array = [
      ['key', 'de', 'en'],
      ['key', 'value1', 'value2'],
    ]
    I18nTools::Arrayer.load(hash).should == array
    I18nTools::Hasher.load(array).should == hash
  end

  it "should build simple with two entries" do
    hash = {
      'de' => { 
        'key1' => 'value1',
        'key2' => 'value2',
      },
    }
    array = [
      ['key', 'de'],
      ['key1', 'value1'],
      ['key2', 'value2'],
    ]
    I18nTools::Arrayer.load(hash).should == array
    I18nTools::Hasher.load(array).should == hash
  end

  it "should build simple with one scoped entry" do
    hash = {
      'de' => { 
        'scope' => { 
          'key' => 'value',
        },
      },
    }
    array = [
      ['key', 'de'],
      ['scope.key', 'value'],
    ]
    I18nTools::Arrayer.load(hash).should == array
    I18nTools::Hasher.load(array).should == hash
  end

  it "should build simple with one deep scoped entry" do
    hash = {
      'de' => { 
        'scope1' => { 
          'scope2' => { 
            'scope3' => { 
              'key' => 'value',
            },
          },
        },
      },
    }
    array = [
      ['key', 'de'],
      ['scope1.scope2.scope3.key', 'value'],
    ]
    I18nTools::Arrayer.load(hash).should == array
    I18nTools::Hasher.load(array).should == hash
  end

  it "should build simple with two scoped entries" do
    hash = {
      'de' => { 
        'scope' => { 
          'key1' => 'value1',
          'key2' => 'value2',
        },
      },
    }
    array = [
      ['key', 'de'],
      ['scope.key1', 'value1'],
      ['scope.key2', 'value2'],
    ]
    I18nTools::Arrayer.load(hash).should == array
    I18nTools::Hasher.load(array).should == hash
  end

  it "should build simple with two different headers" do
    hash = {
      'de' => { 'key1' => 'value1' },
      'en' => { 'key2' => 'value2' },
    }
    array = [
      ['key', 'de', 'en'],
      ['key1', 'value1', 'key1'],
      ['key2', 'key2', 'value2'],
    ]
    merged_hash = {
      'de' => { 
        'key1' => 'value1',
        'key2' => 'key2',
      },
      'en' => { 
        'key1' => 'key1',
        'key2' => 'value2',
      },
    }
    I18nTools::Arrayer.load(hash).should == array
    I18nTools::Hasher.load(array).should == merged_hash
  end

  it "should build simple with a same and two different headers" do
    hash = {
      'de' => { 
        'key' => 'valueA',
        'key1' => 'value1',
      },
      'en' => { 
        'key' => 'valueB',
        'key2' => 'value2',
      },
    }
    array = [
      ['key', 'de', 'en'],
      ['key', 'valueA', 'valueB'],
      ['key1', 'value1', 'key1'],
      ['key2', 'key2', 'value2'],
    ]
    merged_hash = {
      'de' => { 
        'key' => 'valueA',
        'key1' => 'value1',
        'key2' => 'key2',
      },
      'en' => { 
        'key' => 'valueB',
        'key1' => 'key1',
        'key2' => 'value2',
      },
    }
    I18nTools::Arrayer.load(hash).should == array
    I18nTools::Hasher.load(array).should == merged_hash
  end
end
