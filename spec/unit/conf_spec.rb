require "spec_helper"
require "stringio"

describe "Deployment::Conf" do

  before(:all) do
    @content = {'key_0' => '0', 'key_1' => '1', 'key_2' => '2'}
  end

  it "loads conf file to hash" do
    file = StringIO.new %{key_0 : 0\nkey_1 : 1\nkey_2 : 2}
    Deployment::Conf.load_file(file).should == @content
  end

  it "dumps conf hash to file" do
    file = StringIO.new
    expected =<<-EOF
key_0 : 0
key_1 : 1
key_2 : 2
    EOF

    Deployment::Conf.dump(@content, file)
    file.string.should == expected
  end
end