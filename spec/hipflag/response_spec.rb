require 'spec_helper'

RSpec.describe Hipflag::Response do
  let(:response) { double }

  subject { Hipflag::Response.new(response) }

  describe '#json' do
    let(:response) do
      double(body: '{"foo":"bar"}')
    end

    it 'returns response parsed body' do
      expect(subject.json).to eq('foo' => 'bar')
    end
  end

  describe '#ok?' do
    context 'when response code is 200' do
      before { expect(response).to receive(:status).and_return(200) }

      it { expect(subject).to be_ok }
    end

    context 'when response code is not 200' do
      before { expect(response).to receive(:status).and_return(404) }

      it { expect(subject).not_to be_ok }
    end
  end

  describe '#created?' do
    context 'when response code is 201' do
      before { expect(response).to receive(:status).and_return(201) }

      it { expect(subject).to be_created }
    end

    context 'when response code is not 201' do
      before { expect(response).to receive(:status).and_return(404) }

      it { expect(subject).not_to be_created }
    end
  end

  describe '#unauthorized?' do
    context 'when response code is 401' do
      before { expect(response).to receive(:status).and_return(401) }

      it { expect(subject).to be_unauthorized }
    end

    context 'when response code is not 401' do
      before { expect(response).to receive(:status).and_return(200) }

      it { expect(subject).not_to be_unauthorized }
    end
  end

  describe '#no_content?' do
    context 'when response code is 204' do
      before { expect(response).to receive(:status).and_return(204) }

      it { expect(subject).to be_no_content }
    end

    context 'when response code is not 204' do
      before { expect(response).to receive(:status).and_return(404) }

      it { expect(subject).not_to be_no_content }
    end
  end

  describe '#not_found?' do
    context 'when response code is 404' do
      before { expect(response).to receive(:status).and_return(404) }

      it { expect(subject).to be_not_found }
    end

    context 'when response code is not 404' do
      before { expect(response).to receive(:status).and_return(200) }

      it { expect(subject).not_to be_not_found }
    end
  end

  describe '#unprocessable?' do
    context 'when response code is 422' do
      before { expect(response).to receive(:status).and_return(422) }

      it { expect(subject).to be_unprocessable }
    end

    context 'when response code is not 422' do
      before { expect(response).to receive(:status).and_return(200) }

      it { expect(subject).not_to be_unprocessable }
    end
  end

  describe '#server_error?' do
    context 'when response code is 500' do
      before { expect(response).to receive(:status).and_return(500) }

      it { expect(subject).to be_server_error }
    end

    context 'when response code is greater than 500' do
      before { expect(response).to receive(:status).and_return(501) }

      it { expect(subject).to be_server_error }
    end

    context 'when response code is less than 500' do
      before { expect(response).to receive(:status).and_return(400) }

      it { expect(subject).not_to be_server_error }
    end
  end
end
