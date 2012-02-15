require "spec_helper"
require "stringio"

describe "Deployment::Conf" do

  context "simple" do

    before(:all) do
      @content = {'key_0' => '0', 'key_1' => '1', 'key_2' => '2'}
    end

    it "loads" do
      file = StringIO.new %{key_0 : 0\nkey_1 : 1\nkey_2 : 2}
      Deployment::Conf.load_file(file).should == @content
    end

    it "dumps" do
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

  context "with sub-features" do

    it "loads"

    it "dumps sub" do
      content = { 'feature' => { 'sub' => {'key_0' => 'val 0', 'key_1' => 'val 1'}}}
      file = StringIO.new
      expected =<<-EOF
[feature]
[.sub]
key_0 : val 0
key_1 : val 1
      EOF

      Deployment::Conf.dump(content, file)
      file.string.should == expected
    end

    it "dumps sub-sub" do
      content = { 'feature' => { 'sub' => {'key_0' => 'val 0', 'sub_sub' => {'key_00' => 'val 00'}}}}
      file = StringIO.new
      expected =<<-EOF
[feature]
[.sub]
key_0 : val 0
[..sub_sub]
key_00 : val 00
      EOF

      Deployment::Conf.dump(content, file)
      file.string.should == expected
    end

    it "dumps sub sub" do
      content = { 'feature' => {
        'sub_0' => {'s0_k0' => 's0 v0', 's0_k1' => 's0 v1'},
        'sub_1' => {'s1_k0' => 's1 v0', 's1_k1' => 's1 v1'}}}
      file = StringIO.new
      expected =<<-EOF
[feature]
[.sub_0]
s0_k0 : s0 v0
s0_k1 : s0 v1
[.sub_1]
s1_k0 : s1 v0
s1_k1 : s1 v1
      EOF

      Deployment::Conf.dump(content, file)
      file.string.should == expected
    end

    it "dumps sub-sub sub" do
      content = { 'feature' => {
        'sub_0' => {'s0_k0' => 's0 v0', 'sub_0_0' => {'s0_s0_k0' => 's0 s0 v0'}},
        'sub_1' => {'s1_k0' => 's1 v0', 's1_k1' => 's1 v1'}}}
      file = StringIO.new
      expected =<<-EOF
[feature]
[.sub_0]
s0_k0 : s0 v0
[..sub_0_0]
s0_s0_k0 : s0 s0 v0
[.sub_1]
s1_k0 : s1 v0
s1_k1 : s1 v1
      EOF

      Deployment::Conf.dump(content, file)
      file.string.should == expected
    end

    it "dumps sub-sub-sub sub sub-sub" do
      content = {
        'feature' => {
          'sub_0' => {'s0_k0' => 's0 v0',
            'sub_0_0' => {'s0_s0_k0' => 's0 s0 v0',
              'sub_0_0_0' => {'s0_s0_s0_k0' => 's0 s0 s0 v0'}}},
          'sub_1' => {'s1_k0' => 's1 v0', 's1_k1' => 's1 v1'},
          'sub_2' => {'s2_k0' => 's2 v0',
            'sub_2_0' => {'s2_s0_k0' => 's2 s0 v0'}}
        }
      }
      file = StringIO.new
      expected =<<-EOF
[feature]
[.sub_0]
s0_k0 : s0 v0
[..sub_0_0]
s0_s0_k0 : s0 s0 v0
[...sub_0_0_0]
s0_s0_s0_k0 : s0 s0 s0 v0
[.sub_1]
s1_k0 : s1 v0
s1_k1 : s1 v1
[.sub_2]
s2_k0 : s2 v0
[..sub_2_0]
s2_s0_k0 : s2 s0 v0
      EOF

      Deployment::Conf.dump(content, file)
      file.string.should == expected
    end
  end

  context "with sub-features as array" do

  end

end