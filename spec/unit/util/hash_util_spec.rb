require "spec_helper"

describe "HashUtil" do

  include Deployment::HashUtil

  it "changes symbol occurrences to string" do
    hash = {}
    hash[:key_0] = :val_0
    hash[:key_1] = :val_1
    hash[:key_2] = :val_2

    result = stringify hash

    result.should == {'key_0' => 'val_0', 'key_1' => 'val_1', 'key_2' => 'val_2'}
  end
end