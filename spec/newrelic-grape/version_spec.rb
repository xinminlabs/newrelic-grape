require 'spec_helper'

describe NewRelic::Grape do
  it "has a version" do
    NewRelic::Grape::VERSION.should_not be_nil
  end
end
