require "spec_helper"

describe "ConfDSL" do

  before(:all) do
    @dsl = Deployment::ConfDSL.new
  end

  describe ".add" do
    
    it "one entry" do
      @dsl.content = {}
      platform_descriptor =<<-END
        add :key => 'value'
      END
      expected = { 'key' => 'value' }

      @dsl.instance_eval platform_descriptor
      @dsl.content.should == expected
    end

    it "multi entries" do
      @dsl.content = {}
      platform_descriptor =<<-END
        add :key_0 => 'val 0'
        add :key_1 => 'val 1'
      END
      expected = { 'key_0' => 'val 0', 'key_1' => 'val 1' }

      @dsl.instance_eval platform_descriptor
      @dsl.content.should == expected
    end

    it "sub" do
      @dsl.content = {}
      platform_descriptor =<<-END
        add :feature do
          _ :sub do
            _ :key_0 => 'val 0'
            _ :key_1 => 'val 1'
          end
        end
      END
      expected = { 'feature' => { 'sub' => {'key_0' => 'val 0', 'key_1' => 'val 1'} }}

      @dsl.instance_eval platform_descriptor
      @dsl.content.should == expected
    end


    it "sub sub" do
      pending 'TODO'
      @dsl.content = {}
      platform_descriptor =<<-END
        add :feature do
          _ :sub_0 do
            _ :key_00 => 'val 00'
            _ :key_01 => 'val 01'
          end

          _ :sub_1 do
            _ :key_10 => 'val 10'
            _ :key_11 => 'val 11'
          end
        end
      END
      expected = {
        'feature' => {
          'sub_0' => {'key_00' => 'val 00', 'key_01' => 'val 01'}              ,
          'sub_1' => {'key_10' => 'val 10', 'key_11' => 'val 11'}
        }
      }

      @dsl.instance_eval platform_descriptor
      @dsl.content.should == expected
    end
    
    it "sub-sub sub" do
      pending 'TODO'
      @dsl.content = {}
      platform_descriptor =<<-END
        add :feature do
          _ :sub_0 do
            _ :s0_k0 => 's0 v0'
            _ :s0_k1 => 's0 v1'
            _ :sub_00 do
              _ :s00_k0 => 's00 v0'
              _ :s00_k1 => 's00 v1'
            end
          end

          _ :sub_1 do
            _ :s1_k0 => 's1 v0'
            _ :s1_k1 => 's1 v1'
          end
        end
      END
      expected = {
        'feature' => {
          'sub_0' => {
            's0_k0' => 's0 v0',
            's0_k1' => 's0 v1',
            'sub_00' => {'s00_k0' => 's00 v0', 's00_k1' => 's00 v1'}
          },
          'sub_1' => {'s1_k0' => 's1 v0', 's1_k1' => 's1 v1'}
        }
      }

      @dsl.instance_eval platform_descriptor
      @dsl.content.should == expected
    end

    it "@sub @sub" do
      pending 'TODO'
      @dsl.content = {}
      platform_descriptor =<<-END
        add :feature do
          _ :sub, 0 do
            _ :s_key_0 => 's val 00'
            _ :s_key_1 => 's val 01'
          end

          _ :sub, 1 do
            _ :s_key_0 => 's val 10'
            _ :s_key_1 => 's val 11'
          end

          _ :lib, 0 do
            _ :l_key_0 => 'l val 00'
            _ :l_key_1 => 'l val 01'
          end

          _ :lib, 1 do
            _ :l_key_0 => 'l val 10'
            _ :l_key_1 => 'l val 11'
          end
        end
      END
      expected =
        { 'feature' =>
          {
            'sub' => 
              [
                {'s_key_0' => 'val 00', 's_key_1' => 'val 01'},
                {'s_key_0' => 'val 10', 's_key_1' => 'val 11'}
              ],
            'lib' =>
              [
                {'l_key_0' => 'val 00', 'l_key_1' => 'val 01'},
                {'l_key_0' => 'val 10', 'l_key_1' => 'val 11'}
              ]
          }
        }

      @dsl.instance_eval platform_descriptor
      @dsl.content.should == expected
    end
  end  # describe - add

  describe ".upd" do

    it "one entry" do
      @dsl.content = { 'key_0' => 'val 0', 'key_1' => 'val 1' }
      platform_descriptor =<<-END
        upd :key_0 => 'upd 0'
      END
      expected = { 'key_0' => 'upd 0', 'key_1' => 'val 1' }

      @dsl.instance_eval platform_descriptor
      @dsl.content.should == expected
    end

    it "multi entries" do
      @dsl.content = { 'key_0' => 'val 0', 'key_1' => 'val 1' }
      platform_descriptor =<<-END
        upd :key_0 => 'upd 0'
        upd :key_1 => 'upd 1'
      END
      expected = { 'key_0' => 'upd 0', 'key_1' => 'upd 1' }

      @dsl.instance_eval platform_descriptor
      @dsl.content.should == expected
    end
  end  # describe - upd

  describe ".del" do
    it "one entry" do
      @dsl.content = { 'key_0' => 'val 0', 'key_1' => 'val 1' }
      platform_descriptor =<<-END
        del :key_0
      END
      expected = { 'key_1' => 'val 1' }

      @dsl.instance_eval platform_descriptor
      @dsl.content.should == expected
    end

    it "multi entries" do
      @dsl.content = { 'key_0' => 'val 0', 'key_1' => 'val 1' }
      platform_descriptor =<<-END
        del :key_0
        del :key_1
      END
      expected = {}

      @dsl.instance_eval platform_descriptor
      @dsl.content.should == expected
    end
  end  # describe - del
end