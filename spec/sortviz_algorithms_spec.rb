require 'spec_helper'

describe Sortviz::Algorithms do
  before do
  end

  subject { Sortviz::Algorithms }

  it 'should create a new algorithm entry with the name given to #define' do
    subject.define('Fake Sort') {}
    expect(subject.plugins.length).to eq(1)
  end
end
