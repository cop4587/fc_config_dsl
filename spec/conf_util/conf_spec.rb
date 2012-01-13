require "spec_helper"
require "stringio"

describe "ConfUtil::Conf" do

  before(:all) do


  end

  it "loads conf file to hash" do
    file = StringIO.new %{key_0 : 0\nkey_1 : 1\nkey_2 : 2}
    content = ConfUtil::Conf.load_file(file)
    content.class.should == Hash
    content.should == {'key_0' => '0', 'key_1' => '1', 'key_2' => '2'}
  end

  it "dumps conf hash to file" do
    content = {'key_0' => '0', 'key_1' => '1', 'key_2' => '2'}
    path = 'spec/conf_util/dumped.conf'
    expected =<<-EOF
key_0 : 0
key_1 : 1
key_2 : 2
    EOF

    File.open(path, 'w') { |f| ConfUtil::Conf.dump(content, f) }
    actual = File.open(path, 'r') { |f| f.read }
    actual.should == expected
  end
end