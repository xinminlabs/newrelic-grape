require 'spec_helper'

describe NewRelic::Agent::Instrumentation::Grape do

  subject { Class.new(Grape::API) }

  def app
    subject
  end

  before do
    subject.get :hello do
      "Hello World"
    end
  end

  it "perform_action_with_newrelic_trace" do
    NewRelic::Agent::Instrumentation::Grape.any_instance.should_receive(:perform_action_with_newrelic_trace).and_yield
    get "/hello"
    last_response.status.should == 200
    last_response.body.should == "Hello World"
  end

  it "not disabled?" do
    NewRelic::Agent::Instrumentation::Grape.should_not be_disabled
  end

  context "disable_grape" do
    before do
      ::NewRelic::Control.stub(:instance).and_return({ 'disable_grape' => true })
    end
    it "disabled?" do
      NewRelic::Agent::Instrumentation::Grape.should be_disabled
    end
    it "turns off instrumentation" do
      NewRelic::Agent::Instrumentation::Grape.any_instance.should_not_receive(:perform_action_with_newrelic_trace).and_yield
      get "/hello"
      last_response.status.should == 200
      last_response.body.should == "Hello World"
    end
  end

  context "DISABLE_NEW_RELIC_GRAPE" do
    before do
      @disable_new_relic_grape = ENV['DISABLE_NEW_RELIC_GRAPE']
      ENV['DISABLE_NEW_RELIC_GRAPE'] = '1'
    end
    it "disabled?" do
      NewRelic::Agent::Instrumentation::Grape.should be_disabled
    end
    it "turns off instrumentation" do
      NewRelic::Agent::Instrumentation::Grape.any_instance.should_not_receive(:perform_action_with_newrelic_trace).and_yield
      get "/hello"
      last_response.status.should == 200
      last_response.body.should == "Hello World"
    end
    after do
      ENV['DISABLE_NEW_RELIC_GRAPE'] = @disable_new_relic_grape
    end
  end

end


