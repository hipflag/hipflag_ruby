require 'spec_helper'

RSpec.describe Hipflag::Configurable do
  it 'allows to configure token' do
    expect(Hipflag::Configurable::OPTIONS).to eq([:public_key, :secret_key])
  end

  describe '.configure' do
    described_class::OPTIONS.each do |key|
      before do
        Hipflag.configure { |config| config.send("#{key}=", key) }
      end

      it "sets #{key}" do
        expect(Hipflag.send(key)).to eq(key)
      end
    end
  end
end
