require File.dirname(__FILE__) + "/../lib/i18n/hasher.rb"

describe I18n::Hasher do
  it "should build empty hash" do
    I18n::Hasher.load.should == {}
  end

  it "should raise if only headers set" do
    lambda { I18n::Hasher.load([[:key, :de]]) }.should raise_error
  end

  it "should build simple two locales hash" do
    I18n::Hasher.load([:key, :de, :en], ['key', 'Wert', 'value']).should == { 'de' => { 'key' => 'Wert' }, 'en' => { 'key' => 'value' } }
  end

  it "should build simple hash" do
    I18n::Hasher.load([:key, :de], ['key', 'value']).should == { 'de' => { 'key' => 'value' } }
  end

  it "should build simple nested hash" do
    I18n::Hasher.load([:key, :de], ['scope.key', 'value']).should == { 'de' => { 'scope' => { 'key' => 'value' } } }
  end

  it "should build deep simple nested hash" do
    I18n::Hasher.load([:key, :de], ['a.b.c.d.key', 'value']).should == { 'de' => { 'a' => { 'b' => { 'c' => { 'd' => { 'key' => 'value' } } } } } }
  end
end
