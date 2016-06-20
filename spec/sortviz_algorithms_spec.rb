require 'spec_helper'

describe Sortviz::Algorithms do
  before do
  end

  subject { Sortviz::Algorithms }

  it 'should create a new algorithm entry with the name given to #define' do
    subject.define('Fake Sort') {}
    expect(subject.plugins.length).to eq(1)
  end

  it 'should evaluate the block given to #define in the context of Sortviz::Algorithms' do
    subject.define 'Empire Sort' do
      author 'Luke Skywalker'
      url 'http://www.starwars.com'
      name :'empire-sort'
      sort { puts 'the force is weak with this one' }
    end
    expect(subject.plugins.last[:author]).to eq('Luke Skywalker')
    expect(subject.plugins.last[:url]).to eq('http://www.starwars.com')
    expect(subject.plugins.last[:name]).to eq(:'empire-sort')
    expect(subject.plugins.last[:sort]).to respond_to(:call)
  end
end
