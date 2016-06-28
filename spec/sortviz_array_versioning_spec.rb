require 'spec_helper'

describe 'Monkey patched Array' do
  subject { Array[1,2,3] }

  it 'should respond to #versions on an Array' do
    expect(subject).to respond_to(:versions)
  end

  it 'should respond to #mark_version on an Array' do
    expect(subject.respond_to?(:mark_version, true)).to be_truthy
  end

  it 'should have one version after #swap! is invoked' do
    subject.swap!(0, 2)
    expect(subject.versions.size).to eq(1)
  end
end
