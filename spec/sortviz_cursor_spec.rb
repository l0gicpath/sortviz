require 'spec_helper'

describe Sortviz::Cursor do
  before do
    @screen = double("screen")
    allow(@screen).to receive(:setpos)
  end

  subject { Sortviz::Cursor.new(@screen, {y: 0, x: 0}) }

  it 'can create cursor and update its y, x position correctly' do
    expect(subject.y).to eq(0)
    expect(subject.x).to eq(0)
  end

  it 'can #move to coordinates correctly' do
    subject.move(5, 2)
    expect(subject.y).to eq(5)
    expect(subject.x).to eq(2)
  end

  it 'can move to a y coordinate correctly' do
    subject.move_y(10)
    expect(subject.y).to eq(10)
  end

  it 'can move to a x coordinate correctly' do
    subject.move_x(20)
    expect(subject.x).to eq(20)
  end

  it 'can increment y by a value' do
    subject.move_y(1)
    subject.incr_y(10)
    expect(subject.y).to eq(11)
    subject.incr_y # Default incremental of 1
    expect(subject.y).to eq(12)
  end

  it 'can decrement y by a value' do
    subject.move_y(10)
    subject.decr_y(5)
    expect(subject.y).to eq(5)
    subject.decr_y # Default decremental of 1
    expect(subject.y).to eq(4)
  end

  it 'can increment y by a value' do
    subject.move_x(1)
    subject.incr_x(10)
    expect(subject.x).to eq(11)
    subject.incr_x # Default incremental of 1
    expect(subject.x).to eq(12)
  end

  it 'can decrement x by a value' do
    subject.move_x(10)
    subject.decr_x(5)
    expect(subject.x).to eq(5)
    subject.decr_x # Default decremental of 1
    expect(subject.x).to eq(4)
  end

  it 'should cache old coordinates and restore them correctly' do
    subject.move(5, 10)
    subject.cache
    subject.move(10, 20)
    expect(subject.y).to eq(10)
    expect(subject.x).to eq(20)
    subject.restore
    expect(subject.y).to eq(5)
    expect(subject.x).to eq(10)
  end

  it 'should switch to a new window correctly' do
    snd_screen = double("snd_screen")
    allow(snd_screen).to receive(:setpos)
    
    fst_screen = subject.window
    subject.switch_window(snd_screen)
    expect(subject.window).to_not be(fst_screen)
  end

  it 'should move to new coordinates in a new screen if we passed them' do
    snd_screen = double("snd_screen")
    allow(snd_screen).to receive(:setpos)
    subject.switch_window(snd_screen, coords: {y: 10, x: 5})
    expect(subject.y).to eq(10)
    expect(subject.x).to eq(5)
  end
end
