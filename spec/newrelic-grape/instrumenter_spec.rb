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

end


