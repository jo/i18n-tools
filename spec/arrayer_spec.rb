require File.dirname(__FILE__) + "/../lib/i18n/arrayer.rb"

describe I18n::Arrayer do
  it "should build empty array" do
    I18n::Arrayer.load.should == []
  end

  it "should build empty array with headers" do
    I18n::Arrayer.load('de' => {}).should == [['key', 'de']]
  end

  it "should build empty array with two headers" do
    I18n::Arrayer.load('de' => {}, 'en' => {}).should == [['key', 'de', 'en']]
  end

  it "should build simple array" do
    I18n::Arrayer.load('de' => { 'key' => 'value' }).should == [['key', 'de'], ['key', 'value']]
  end
end
