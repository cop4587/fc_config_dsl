require "spec_helper"
require "stringio"

describe "Conf" do

  context "simple" do

    before(:all) do
      @content = {'key_0' => '0', 'key_1' => '1', 'key_2' => '2'}
    end

    it ".loads" do
      file = StringIO.new %{key_0 : 0\nkey_1 : 1\nkey_2 : 2}
      Deployment::Conf.load_file(file).should == @content
    end

    it ".dumps" do
      file = StringIO.new
      expected =<<-EOF
key_0 : 0
key_1 : 1
key_2 : 2
      EOF

      Deployment::Conf.dump(@content, file)
      file.string.should == expected
    end
  end  # content simple

  context "with sub(s)" do

    describe ".loads" do

      it "feature" do
        content =<<-EOF
[feature]
key_0 : val 0
key_1 : val 1
        EOF
        file = StringIO.new content
        expected = { 'feature' => {'key_0' => 'val 0', 'key_1' => 'val 1'}}

        loaded = Deployment::Conf.load_file(file)
        loaded.should == expected
      end

      it "feature-sub" do
        content =<<-EOF
[feature]
[.sub]
key_0 : val 0
key_1 : val 1
        EOF
        file = StringIO.new content
        expected = { 'feature' => { 'sub' => {'key_0' => 'val 0', 'key_1' => 'val 1'}}}

        loaded = Deployment::Conf.load_file(file)
        loaded.should == expected
      end

      it "feature-sub-sub" do
        content =<<-EOF
[feature]
[.sub]
key_0 : val 0
key_1 : val 1
[..sub_sub]
key_00 : val 00
key_01 : val 01
        EOF
        file = StringIO.new content
        expected = { 'feature' => { 'sub' => {'key_0' => 'val 0', 'key_1' => 'val 1',
                                              'sub_sub' => {'key_00' => 'val 00', 'key_01' => 'val 01'}}}}

        loaded = Deployment::Conf.load_file(file)
        loaded.should == expected
      end

      it "feature-sub-sub teacher" do
        content =<<-EOF
[feature]
[.sub]
key_0 : val 0
key_1 : val 1
[..sub_sub]
key_00 : val 00
key_01 : val 01
[teacher]
hot : lll
lib : vvv
        EOF
        file = StringIO.new content
        expected = {
          'feature' => {
            'sub' => {
              'key_0' => 'val 0',
              'key_1' => 'val 1',
              'sub_sub' => {
                'key_00' => 'val 00',
                'key_01' => 'val 01' }}},
          'teacher' => {
            'hot' => 'lll',
            'lib' => 'vvv' }}

        loaded = Deployment::Conf.load_file(file)
        loaded.should == expected
      end

      it "feature-{sub sub}" do
        content =<<-EOF
[feature]
[.sub]
key_0 : val 0
key_1 : val 1
[.tub]
tey_0 : tal 0
tey_1 : tal 1
        EOF
        file = StringIO.new content
        expected = { 'feature' => { 'sub' => {'key_0' => 'val 0', 'key_1' => 'val 1'},
                                    'tub' => {'tey_0' => 'tal 0', 'tey_1' => 'tal 1'}}}

        loaded = Deployment::Conf.load_file(file)
        loaded.should == expected
      end

      it "feature-{sub-sub sub}" do
        content =<<-EOF
[feature]
[.sub_0]
s0k0 : s0v0
s0k1 : s0v1
[..sub_sub]
key_00 : val 00
key_01 : val 01
[.sub_1]
s1k0 : s1v0
s1k1 : s1v1
        EOF
        file = StringIO.new content
        expected = {'feature' => {'sub_0' => {'s0k0' => 's0v0', 's0k1' => 's0v1',
                                    'sub_sub' => {'key_00' => 'val 00', 'key_01' => 'val 01'}},
                                  'sub_1' => {'s1k0' => 's1v0', 's1k1' => 's1v1'}}}

        loaded = Deployment::Conf.load_file(file)
        loaded.should == expected
      end

      it "k:v feature-{sub-sub sub}" do
        content =<<-EOF
key : val
[feature]
[.sub_0]
s0k0 : s0v0
s0k1 : s0v1
[..sub_sub]
key_00 : val 00
key_01 : val 01
[.sub_1]
s1k0 : s1v0
s1k1 : s1v1
        EOF
        file = StringIO.new content
        expected = {
            'key' => 'val',
            'feature' => {'sub_0' => {'s0k0' => 's0v0', 's0k1' => 's0v1',
                                      'sub_sub' => {'key_00' => 'val 00', 'key_01' => 'val 01'}},
                          'sub_1' => {'s1k0' => 's1v0', 's1k1' => 's1v1'}}}

        loaded = Deployment::Conf.load_file(file)
        loaded.should == expected
      end
    end # describe - loads with sub(s)

    describe ".dumps" do
      
      it "feature-sub" do
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

      it "feature-sub-sub" do
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

      it "feature-{sub sub}" do
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

      it "feature-{sub-sub sub}" do
        content = { 'feature' => {
          'sub_0' => {'s0_k0' => 's0 v0',
                      'sub_0_0' => {'s0_s0_k0' => 's0 s0 v0'}},
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

      it "feature-{sub-sub-sub sub sub-sub}" do
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
    end  # describe - dumps
  end  # context with sub(s)

  context "with @sub(s)" do

    describe ".loads" do

      it "feature-{@sub @sub}" do
        #pending
        content =<<-EOF
[feature]
[.@sub]
hot : foo
lib : bar
[.@sub]
hot : lll
lib : vvv
        EOF
        file = StringIO.new content
        expected = {
          'feature' => {
            'sub' => {
              '0' => {'hot' => 'foo', 'lib' => 'bar'},
              '1' => {'hot' => 'lll', 'lib' => 'vvv'}}}}
        loaded = Deployment::Conf.load_file(file)
        loaded.should == expected
      end

      it "feature-{@sub-tub @sub}" do
        pending "To Be Fixed"
        content =<<-EOF
[feature]
[.@sub]
hot : foo
lib : bar
[..tub]
key : val
[.@sub]
hot : lll
lib : vvv
        EOF
        file = StringIO.new content
        expected = {
          'feature' => {
            'sub' => {
              '0' => {'hot' => 'foo', 'lib' => 'bar', 'tub' => { 'key' => 'val'}},
              '1' => {'hot' => 'lll', 'lib' => 'vvv'}}}}
        loaded = Deployment::Conf.load_file(file)
        loaded.should == expected
      end

      it "@sub-sub @sub @lib @lib"

      it "feature-{@sub @sub @tub @tub}" do
        pending 'PASSED (interfere with others)'
        content =<<-EOF
[feature]
[.@sub]
hot : foo
lib : bar
[.@sub]
hot : lll
lib : vvv
[.@tub]
hot : foo
lib : bar
[.@tub]
hot : lll
lib : vvv
        EOF
        file = StringIO.new content
        expected = {
          'feature' => {
            'sub' => {
              '0' => {'hot' => 'foo', 'lib' => 'bar'},
              '1' => {'hot' => 'lll', 'lib' => 'vvv'}},
            'tub' => {
              '0' => {'hot' => 'foo', 'lib' => 'bar'},
              '1' => {'hot' => 'lll', 'lib' => 'vvv'}}}}
        loaded = Deployment::Conf.load_file(file)
        loaded.should == expected
      end

      it "feature-{@sub @sub-{@tub @tub}}" do
        pending
        content =<<-EOF
[feature]

[.@sub]
hot : foo
lib : bar

[..@tub]
a_key : a_val_0
b_key : b_val_0

[.@sub]
hot : lll
lib : vvv

[..@tub]
a_key : a_val_1
b_key : b_val_1
        EOF
        file = StringIO.new content
        expected = {
          'feature' => {
            'sub' => {
              '0' => {'hot' => 'foo',
                      'lib' => 'bar',
                      'tub' => {'a_key' => 'a_val_0', 'b_key' => 'b_val_0'}},
              '1' => {'hot' => 'lll',
                      'lib' => 'vvv',
                      'tub' => {'a_key' => 'a_val_1', 'b_key' => 'b_val_1'}}}}}
        loaded = Deployment::Conf.load_file(file)
        loaded.should == expected
      end

      it "sub-sub-@lib @lib tub" do
        pending 'To Be Fixed'
        content =<<-EOF
[feature]

[.sub]
key : val

[..sub_sub]
key : val

[...@lib]
hot : foo
lib : bar

[...@lib]
hot : lll
lib : vvv

[.tub]
key : val
        EOF
        file = StringIO.new content
        expected = {
          'feature' => {
            'sub' => {
              'key' => 'val',
              'sub_sub' => {
                'key' => 'val',
                'lib' => {
                  '0' => { 'hot' => 'foo', 'lib' => 'bar'},
                  '1' => { 'hot' => 'lll', 'lib' => 'vvv'}}}},
            'tub' => { 'key' => 'val'}}}
        loaded = Deployment::Conf.load_file(file)
        loaded.should == expected
      end
    end  # describe loads

    describe ".dumps" do

      it "@feature @feature" do
        content = {
          'feature' => {
            '0' => {'host' => 'foo', 'lib' => 'vvv'},
            '1' => {'host' => 'bar', 'lib' => 'kkk'}}}

        file = StringIO.new
        expected =<<-EOF
[@feature]
host : foo
lib : vvv
[@feature]
host : bar
lib : kkk
        EOF

        Deployment::Conf.dump(content, file)
        file.string.should == expected
      end

      it "feature-{@sub @sub}" do
        content = {
          'feature' => {
            'sub' => {
               '0' => {'host' => 'foo', 'lib' => 'vvv'},
               '1' => {'host' => 'bar', 'lib' => 'kkk'}}}}

        file = StringIO.new
        expected =<<-EOF
[feature]
[.@sub]
host : foo
lib : vvv
[.@sub]
host : bar
lib : kkk
        EOF

        Deployment::Conf.dump(content, file)
        file.string.should == expected
      end

      it "this-{@sub @sub} that-{@tub @tub}" do
        content = {
          'this' => {
            'sub' => {
               '0' => {'host' => 'foo', 'lib' => 'vvv'},
               '1' => {'host' => 'bar', 'lib' => 'kkk'}}},
          'that' => {
            'tub' => {
               '0' => {'host' => 'foo', 'lib' => 'vvv'},
               '1' => {'host' => 'bar', 'lib' => 'kkk'}}}}

        file = StringIO.new
        expected =<<-EOF
[this]
[.@sub]
host : foo
lib : vvv
[.@sub]
host : bar
lib : kkk
[that]
[.@tub]
host : foo
lib : vvv
[.@tub]
host : bar
lib : kkk
        EOF

        Deployment::Conf.dump(content, file)
        file.string.should == expected
      end

      it "feature-{@sub-tub @sub}" do
        content = {
          'feature' => {
            'sub' => {
              '0' => {
                'hot' => 'foo',
                'lib' => 'bar',
                'tub' => {
                  'tub_k_0' => 'tub v 0',
                  'tub_k_1' => 'tub v 1'}},
              '1' => {
                'hot' => 'lll',
                'lib' => 'vvv'}}}}
        file = StringIO.new
        expected =<<-EOF
[feature]
[.@sub]
hot : foo
lib : bar
[..tub]
tub_k_0 : tub v 0
tub_k_1 : tub v 1
[.@sub]
hot : lll
lib : vvv
        EOF

        Deployment::Conf.dump(content, file)
        file.string.should == expected
      end

      it "feature-{@sub-tub @sub @lib @lib}" do
        content = {
          'feature' => {
            'sub' => {
              '0' => {
                'host' => 'foo',
                'lib' => 'vvv',
                'tub' => {
                  's0_s0_k0' => 's0 s0 v0',
                  's0_s0_k1' => 's0 s0 v1'}},
              '1' => {
                'host' => 'bar',
                'lib' => 'kkk'}},
            'lib' => {
              '0' => {
                'l_k_0' => 'foo',
                'l_k_1' => 'buz'},
              '1' => {
                'l_k_0' => 'bar',
                'a_key' => 'a val'}}}}
        file = StringIO.new
        expected =<<-EOF
[feature]
[.@sub]
host : foo
lib : vvv
[..tub]
s0_s0_k0 : s0 s0 v0
s0_s0_k1 : s0 s0 v1
[.@sub]
host : bar
lib : kkk
[.@lib]
l_k_0 : foo
l_k_1 : buz
[.@lib]
l_k_0 : bar
a_key : a val
        EOF

        Deployment::Conf.dump(content, file)
        file.string.should == expected
      end

      it "feature-{sub-tub-{@lib @lib} sub}" do
        content = {
          'feature' => {
            'sub_0' => {
              'key_0' => 'val 0',
              'tub' => {
                'key_00' => 'val 00',
                'lib' => {
                  '0' => {
                    's0_s0_k0' => 's0 s0 v0 foo',
                    's0_s0_k1' => 's0 s0 v1 foo'},
                  '1' => {
                    's0_s0_k0' => 's0 s0 v0 bar',
                    's0_s0_k1' => 's0 s0 v1 bar'}}}},
            'sub_1' => {
              'key_1' => 'val 1',
              'key_2' => 'val 2'}}}
        file = StringIO.new
        expected =<<-EOF
[feature]
[.sub_0]
key_0 : val 0
[..tub]
key_00 : val 00
[...@lib]
s0_s0_k0 : s0 s0 v0 foo
s0_s0_k1 : s0 s0 v1 foo
[...@lib]
s0_s0_k0 : s0 s0 v0 bar
s0_s0_k1 : s0 s0 v1 bar
[.sub_1]
key_1 : val 1
key_2 : val 2
        EOF

        Deployment::Conf.dump(content, file)
        file.string.should == expected
      end
    end  # describe - dumps
  end  # context with @sub(s)
end