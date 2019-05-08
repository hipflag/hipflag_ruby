require 'spec_helper'

RSpec.describe Hipflag::Client::Flag do
  let(:flag_id) { 'new-header' }
  let(:client) { Hipflag::Client.new(public_key: 'foo123', secret_key: 'bar123') }

  describe '#flag' do
    let(:body) do
      {
        flag: {
          active: true,
          name: flag_id
        }
      }.to_json
    end

    let(:response) do
      {
        status: 200,
        body: body
      }
    end

    context 'when flag_id does not exist' do
      let(:not_found_response) do
        {
          status: 404,
          body: { message: 'Not found' }.to_json
        }
      end

      subject { client.flag(-123) }

      let(:url) { "#{Hipflag::Client::BASE_URL}flags/-123" }

      it 'raises a NotFound exception' do
        stub_request(:get, url).to_return(not_found_response)

        expect { subject }.to raise_error(Hipflag::Client::NotFound)
      end
    end

    context 'when user_id param is given' do
      subject { client.flag(flag_id, user_id: 123) }

      let(:url) { "#{Hipflag::Client::BASE_URL}flags/#{flag_id}?user_id=123" }

      it 'returns flag information' do
        stub_request(:get, url).to_return(response)

        expect(subject).to be_ok
        expect(subject.body).to eq(body)
      end
    end

    context 'when no params are given' do
      subject { client.flag(flag_id) }

      let(:url) { "#{Hipflag::Client::BASE_URL}flags/#{flag_id}" }

      it 'returns flag information' do
        stub_request(:get, url).to_return(response)

        expect(subject).to be_ok
        expect(subject.body).to eq(body)
      end
    end
  end

  describe '#update_flag' do
    let(:ok_body) do
      {
        flag: {
          enabled: true,
          rollout: 75,
          name: flag_id
        }
      }.to_json
    end

    let(:error_body) do
      {
        message: {
          rollout: ['must be less than or equal to 100']
        }
      }.to_json
    end

    let(:ok_response) do
      {
        status: 200,
        body: ok_body
      }
    end

    let(:unprocessable_response) do
      {
        status: 422,
        body: error_body
      }
    end

    let(:url) { "#{Hipflag::Client::BASE_URL}flags/#{flag_id}" }

    context 'when correct params are given' do
      subject { client.update_flag(flag_id, enabled: true, rollout: 75) }

      it 'updates flag information' do
        stub_request(:put, url)
          .with(body: { flag: { enabled: true, rollout: 75 } }.to_json)
          .to_return(ok_response)


        expect(subject).to be_ok
        expect(subject.body).to eq(ok_body)
      end
    end

    context 'when incorrect params are given' do
      subject { client.update_flag(flag_id, enabled: true, rollout: 120) }

      it 'raises an exception containing the error message' do
        stub_request(:put, url)
          .with(body: { flag: { enabled: true, rollout: 120 } }.to_json)
          .to_return(unprocessable_response)


        expect { subject }.to raise_error(Hipflag::Client::UnprocessableEntity)
      end
    end
  end
end
