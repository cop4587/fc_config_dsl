require "spec_helper"

describe "Deployment::GflagDSL" do

  before(:all) do
    @dsl = Deployment::GflagDSL.new
  end

  describe "add" do
    it "one entry" do
      @dsl.content = []
      platform_descriptor =<<-END
        add :flag_foo => 'yes'
      END
      expected = ['flag_foo']

      @dsl.instance_eval platform_descriptor
      @dsl.content.should == expected
    end

    it "multi entries" do
      @dsl.content = []
      platform_descriptor =<<-END
        add :flag_foo => 'yes'
        add :flag_bar => 'no'
      END
      expected = ['flag_foo', 'noflag_bar']

      @dsl.instance_eval platform_descriptor
      @dsl.content.should == expected
    end
  end

  describe "upd" do

    it "raises exception if gflag not found" do
      @dsl.content = ['flag_foo']
      platform_descriptor =<<-END
        upd :flag_bar => 'no'
      END

      lambda do
        @dsl.instance_eval platform_descriptor
      end.should raise_error "Gflag not found - flag_bar"
    end

    it "one entry" do
      @dsl.content = ['flag_foo', 'noflag_bar']
      platform_descriptor =<<-END
        upd :flag_foo => 'no'
      END
      expected = ['noflag_bar', 'noflag_foo']

      @dsl.instance_eval platform_descriptor
      @dsl.content.should == expected
    end

    it "multi entries" do
      @dsl.content = ['flag_foo', 'noflag_bar']
      platform_descriptor =<<-END
        upd :flag_foo => 'no'
        upd :flag_bar => 'yes'
      END
      expected = ['noflag_foo', 'flag_bar']

      @dsl.instance_eval platform_descriptor
      @dsl.content.should == expected
    end
  end

  describe "del" do

    it "raises exception if gflag not found" do
      @dsl.content = ['flag_foo']
      platform_descriptor =<<-END
        del :flag_bar
      END

      lambda do
        @dsl.instance_eval platform_descriptor
      end.should raise_error "Gflag not found - flag_bar"
    end

    it "one entry" do
      @dsl.content = ['flag_foo', 'noflag_bar']
      platform_descriptor =<<-END
        del :flag_foo
      END
      expected = ['noflag_bar']

      @dsl.instance_eval platform_descriptor
      @dsl.content.should == expected
    end

    it "multi entries" do
      @dsl.content = ['flag_foo', 'noflag_bar']
      platform_descriptor =<<-END
        del :flag_foo
        del :flag_bar
      END
      expected = []

      @dsl.instance_eval platform_descriptor
      @dsl.content.should == expected
    end
  end
end