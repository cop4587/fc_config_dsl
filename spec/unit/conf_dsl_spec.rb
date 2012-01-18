require "spec_helper"

describe "Deployment::ConfDSL" do

  before(:all) do
    @dsl = Deployment::ConfDSL.new
  end

  describe "add" do
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
  end

  describe "upd" do

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
  end

  describe "del" do
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
  end
end