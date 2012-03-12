require "spec_helper"

describe "ConfDSL" do

  before(:each) do
    @dsl = Deployment::ConfDSL.new
  end

  describe ".add" do

    context "simple" do

      it "one entry" do
        platform_descriptor =<<-END
          add :key => 'value'
        END
        expected = { 'key' => 'value' }

        @dsl.instance_eval platform_descriptor
        @dsl.content.should == expected
      end

      it "multi entries" do
        platform_descriptor =<<-END
          add :key_0 => 'val 0'
          add :key_1 => 'val 1'
        END
        expected = { 'key_0' => 'val 0', 'key_1' => 'val 1' }

        @dsl.instance_eval platform_descriptor
        @dsl.content.should == expected
      end
    end  # context - simple

    context "sub" do

      it "feature feature" do
        platform_descriptor =<<-END
          add :f_0 do
            _ :sub_0 do
              _ :key_0 => 'val 0'
              _ :key_1 => 'val 1'
            end
          end

          add :f_1 do
            _ :sub_0 do
              _ :key_0 => 'val 0'
              _ :key_1 => 'val 1'
            end
          end
        END
        expected = {
          'f_0' => { 'sub_0' => {'key_0' => 'val 0', 'key_1' => 'val 1'}},
          'f_1' => { 'sub_0' => {'key_0' => 'val 0', 'key_1' => 'val 1'}}
        }

        @dsl.instance_eval platform_descriptor
        @dsl.content.should == expected
      end

      it "feature-sub" do
        platform_descriptor =<<-END
          add :feature do
            _ :sub_0 do
              _ :key_0 => 'val 0'
              _ :key_1 => 'val 1'
            end
          end
        END
        expected = {
          'feature' => {
             'sub_0' => {'key_0' => 'val 0', 'key_1' => 'val 1'}
          }
        }

        @dsl.instance_eval platform_descriptor
        @dsl.content.should == expected
      end

      it "feature-{sub sub}" do
        platform_descriptor =<<-END
          add :feature do
            _ :sub_0 do
              _ :key_0 => 'val 0'
              _ :key_1 => 'val 1'
            end

            _ :sub_1 do
              _ :key_0 => 'val 0'
              _ :key_1 => 'val 1'
            end
          end
        END
        expected = {
          'feature' => {
             'sub_0' => {'key_0' => 'val 0', 'key_1' => 'val 1'},
             'sub_1' => {'key_0' => 'val 0', 'key_1' => 'val 1'}
          }
        }

        @dsl.instance_eval platform_descriptor
        @dsl.content.should == expected
      end

      it "feature-{sub-sub sub}" do
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

      it "feature-{sub-sub sub sub-sub}" do
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

            _ :sub_2 do
              _ :s0_k0 => 's0 v0'
              _ :s0_k1 => 's0 v1'
              _ :sub_00 do
                _ :s00_k0 => 's00 v0'
                _ :s00_k1 => 's00 v1'
              end
            end
          end
        END
        expected = {
          'feature' => {
            'sub_0' => {
              's0_k0' => 's0 v0',
              's0_k1' => 's0 v1',
              'sub_00' => {'s00_k0' => 's00 v0', 's00_k1' => 's00 v1'}},
            'sub_1' => {'s1_k0' => 's1 v0', 's1_k1' => 's1 v1'},
            'sub_2' => {
              's0_k0' => 's0 v0',
              's0_k1' => 's0 v1',
              'sub_00' => {'s00_k0' => 's00 v0', 's00_k1' => 's00 v1'}}
          }
        }

        @dsl.instance_eval platform_descriptor
        @dsl.content.should == expected
      end
    end  # context - sub

    context "@sub" do

      it "@sub @sub" do
        platform_descriptor =<<-END
          add :feature do
            _ :sub do
              _ 0 do
                _ :host => 'host 0'
                _ :lib  => 'foo'
              end
              _ 1 do
                _ :host => 'host 1'
                _ :lib  => 'bar'
              end
            end
          end
        END
        expected = {
          'feature' => {
            'sub' => {
              '0' => {'host' => 'host 0', 'lib' => 'foo'},
              '1' => {'host' => 'host 1', 'lib' => 'bar'}
            }
          }
        }

        @dsl.instance_eval platform_descriptor
        @dsl.content.should == expected
      end

      it "@sub @sub @tub @tub" do
        platform_descriptor =<<-END
          add :feature do
            _ :sub do
              _ 0 do
                _ :host => 'host 0'
                _ :lib  => 'foo'
              end
              _ 1 do
                _ :host => 'host 1'
                _ :lib  => 'bar'
              end
            end

            _ :tub do
              _ 0 do
                _ :platform => 'platform 0'
                _ :os  => 'os 0'
              end
              _ 1 do
                _ :platform => 'platform 1'
                _ :os  => 'os 1'
              end
            end
          end
        END
        expected = {
          'feature' => {
            'sub' => {
              '0' => {'host' => 'host 0', 'lib' => 'foo'},
              '1' => {'host' => 'host 1', 'lib' => 'bar'}
            },
            'tub' => {
              '0' => {'platform' => 'platform 0', 'os' => 'os 0'},
              '1' => {'platform' => 'platform 1', 'os' => 'os 1'}
            }
          }
        }

        @dsl.instance_eval platform_descriptor
        @dsl.content.should == expected
      end
    end  # context - @sub
  end  # describe - add

  describe ".upd" do

    context "simple" do

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
    end  # context - simple

    context "sub" do

      it "raises error on unknown entry"

      it "feature-sub" do
        @dsl.content = {
          'feature' => {
             'sub_0' => {'key_0' => 'val 0', 'key_1' => 'val 1'}
          }
        }
        platform_descriptor =<<-END
          upd :feature do
            _ :sub_0 do
              _ :key_0 => 'upd 0'
            end
          end
        END
        expected = {
          'feature' => {
             'sub_0' => {'key_0' => 'upd 0', 'key_1' => 'val 1'}
          }
        }

        @dsl.instance_eval platform_descriptor
        @dsl.content.should == expected
      end

      it "feature-{sub sub}" do
        @dsl.content = {
          'feature' => {
             'sub_0' => {'key_00' => 'val 00', 'key_01' => 'val 01'},
             'sub_1' => {'key_10' => 'val 10', 'key_11' => 'val 11'}
          }
        }
        platform_descriptor =<<-END
          upd :feature do
            _ :sub_0 do
              _ :key_00 => 'upd 00'
            end
            _ :sub_1 do
              _ :key_11 => 'upd 11'
            end
          end
        END
        expected = {
          'feature' => {
             'sub_0' => {'key_00' => 'upd 00', 'key_01' => 'val 01'},
             'sub_1' => {'key_10' => 'val 10', 'key_11' => 'upd 11'}
          }
        }

        @dsl.instance_eval platform_descriptor
        @dsl.content.should == expected
      end

      it "sub-sub sub"

      it "sub-sub sub sub-sub"
    end  # context - sub

    context "@sub" do
      it "@sub @sub"

      it "@sub @sub @tub @tub"
    end  # context - @sub
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