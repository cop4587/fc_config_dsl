require "spec_helper"
require "stringio"

describe "Gflag" do

  before(:all) do
    @content = ['flag_foo', 'noflag_bar', 'flag_buz']
  end

  it ".loads" do
    file = StringIO.new %{--flag_foo\n--noflag_bar\n--flag_buz}
    Deployment::Gflag.load_file(file).should == @content
  end

  it ".dumps" do
    file = StringIO.new
    expected =<<-EOF
--flag_foo
--noflag_bar
--flag_buz
    EOF

    Deployment::Gflag.dump(@content, file)
    file.string.should == expected
  end
end