require 'spec_helper'

describe NewRelic::Agent::Instrumentation::Grape do
  subject { Class.new(Grape::API) }

  def app
    subject
  end

  context 'api without version' do
    before do
      subject.get :hello do
        'Hello World'
      end
    end

    it 'perform_action_with_newrelic_trace' do
      expect_any_instance_of(NewRelic::Agent::Instrumentation::Grape)
        .to receive(:perform_action_with_newrelic_trace)
        .with(hash_including(path: 'GET hello'))
        .and_yield

      get '/hello'
      expect(last_response.status).to eq 200
      expect(last_response.body).to eq 'Hello World'
    end
  end

  context 'api with version' do
    context 'in path' do
      before do
        subject.version 'v1', using: :path

        subject.get :hello do
          'Hello World'
        end
      end

      it 'perform_action_with_newrelic_trace' do
        expect_any_instance_of(NewRelic::Agent::Instrumentation::Grape)
          .to receive(:perform_action_with_newrelic_trace)
          .with(hash_including(path: 'GET v1-hello'))
          .and_yield

        get '/v1/hello'

        expect(last_response.status).to eq 200
        expect(last_response.body).to eq 'Hello World'
      end
    end
  end
end
