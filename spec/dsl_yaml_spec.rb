require "spec_helper"

describe "Deployment::DSL - YAML format" do

  before(:each) do
    @dsl = Deployment::DSL.new
  end

  describe "add" do

    context "one entry" do

      it "one element" do
        @dsl.content = {}
        platform_descriptor =<<-END
          add :entry do
            _ :key => 'val'
          end
        END
        expected = { 'entry' => { 'key' => 'val' }}

        @dsl.instance_eval platform_descriptor
        @dsl.content.should == expected
      end

      it "multi elements" do
        @dsl.content = { 'entry_0' => { 'key_0' => '00', 'key_1' => '01' }}
        platform_descriptor =<<-END
          add :entry_1 do
            _ :key_0 => '10'
            _ :key_1 => '11'
          end
        END
        expected = { 'entry_0' => { 'key_0' => '00', 'key_1' => '01' },
                     'entry_1' => { 'key_0' => '10', 'key_1' => '11' }}

        @dsl.instance_eval platform_descriptor
        @dsl.content.should == expected
      end
    end

    context "multi entries" do

      it "one element each" do
        @dsl.content = {}
        platform_descriptor =<<-END
          add :entry_0 do
            _ :key_0 => '0'
          end

          add :entry_1 do
            _ :key_1 => '1'
          end
        END
        expected = { 'entry_0' => { 'key_0' => '0' }, 'entry_1' => { 'key_1' => '1'}}

        @dsl.instance_eval platform_descriptor
        @dsl.content.should == expected
      end

      it "multi elements each" do
        @dsl.content = { 'entry_0' => { 'key_0' => '00', 'key_1' => '01' }}
        platform_descriptor =<<-END
          add :entry_1 do
            _ :key_0 => '10'
            _ :key_1 => '11'
          end

          add :entry_2 do
            _ :key_0 => '20'
            _ :key_1 => '21'
          end
        END
        expected = { 'entry_0' => { 'key_0' => '00', 'key_1' => '01' },
                     'entry_1' => { 'key_0' => '10', 'key_1' => '11' },
                     'entry_2' => { 'key_0' => '20', 'key_1' => '21' }}

        @dsl.instance_eval platform_descriptor
        @dsl.content.should == expected
      end
    end
  end # add

  describe "upd" do

    context "one entry" do

      it "one element" do
        @dsl.content = { 'entry_0' => { 'key_0' => '0', 'key_1' => '1' }}
        platform_descriptor =<<-END
          upd :entry_0 do
            _ :key_0 => 'upd'
          end
        END
        expected = { 'entry_0' => { 'key_0' => 'upd', 'key_1' => '1'}}

        @dsl.instance_eval platform_descriptor
        @dsl.content.should == expected
      end

      it "multi elements" do
        @dsl.content = { 'entry_0' => { 'key_0' => '0', 'key_1' => '1' }}
        platform_descriptor =<<-END
          upd :entry_0 do
            _ :key_0 => 'upd 0'
            _ :key_1 => 'upd 1'
          end
        END
        expected = { 'entry_0' => { 'key_0' => 'upd 0', 'key_1' => 'upd 1'}}

        @dsl.instance_eval platform_descriptor
        @dsl.content.should == expected
      end
    end

    context "multi entries" do

      it "one element each" do
        @dsl.content = { 'entry_0' => { 'key_0' => '00', 'key_1' => '01' },
                         'entry_1' => { 'key_0' => '10', 'key_1' => '11' },}
        platform_descriptor =<<-END
          upd :entry_0 do
            _ :key_0 => 'upd 00'
          end

          upd :entry_1 do
            _ :key_1 => 'upd 11'
          end
        END
        expected = { 'entry_0' => { 'key_0' => 'upd 00', 'key_1' => '01'},
                     'entry_1' => { 'key_0' => '10', 'key_1' => 'upd 11'},}

        @dsl.instance_eval platform_descriptor
        @dsl.content.should == expected
      end

      it "multi elements each" do
        @dsl.content = { 'entry_0' => { 'key_0' => '00', 'key_1' => '01' },
                         'entry_1' => { 'key_0' => '10', 'key_1' => '11' },}
        platform_descriptor =<<-END
          upd :entry_0 do
            _ :key_0 => 'upd 00'
            _ :key_1 => 'upd 01'
          end

          upd :entry_1 do
            _ :key_1 => 'upd 11'
            _ :key_0 => 'upd 10'
          end
        END
        expected = { 'entry_0' => { 'key_0' => 'upd 00', 'key_1' => 'upd 01'},
                     'entry_1' => { 'key_0' => 'upd 10', 'key_1' => 'upd 11'},}

        @dsl.instance_eval platform_descriptor
        @dsl.content.should == expected
      end
    end
  end # upd

  describe "del" do

    it "one entry" do
      @dsl.content = { 'entry_0' => { 'key_0' => '00', 'key_1' => '01' },
                       'entry_1' => { 'key_0' => '10', 'key_1' => '11' },}
      platform_descriptor =<<-END
        del :entry_0
      END
      expected = { 'entry_1' => { 'key_0' => '10', 'key_1' => '11'},}

      @dsl.instance_eval platform_descriptor
      @dsl.content.should == expected
    end

    it "multi entries" do
      @dsl.content = { 'entry_0' => { 'key_0' => '00', 'key_1' => '01' },
                       'entry_1' => { 'key_0' => '10', 'key_1' => '11' },}
      platform_descriptor =<<-END
        del :entry_0
        del :entry_1
      END
      expected = {}

      @dsl.instance_eval platform_descriptor
      @dsl.content.should == expected
    end
  end # del
end