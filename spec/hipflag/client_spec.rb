require 'spec_helper'

RSpec.describe Hipflag::Client do
  describe '#initialize' do
    before do
      Hipflag.configure do |config|
        config.public_key = 'foo123'
        config.secret_key = 'bar123'
      end
    end

    context 'when no options are given' do
      subject { Hipflag::Client.new }

      it 'sets global options' do
        Hipflag::Configurable::OPTIONS.each do |key|
          expect(subject.send(key)).to eq(Hipflag.send(key))
        end
      end
    end

    context 'when custom options are given' do
      subject { Hipflag::Client.new(public_key: 'foo345', secret_key: 'bar345') }

      it 'sets local options' do
        Hipflag::Configurable::OPTIONS.each do |key|
          expect(subject.send(key)).not_to eq(Hipflag.send(key))
        end
      end
    end
  end
end
