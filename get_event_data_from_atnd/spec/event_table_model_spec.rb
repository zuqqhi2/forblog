require File.dirname(__FILE__) + '/spec_helper'

describe EventTableModel, 'when irregular argument' do
  it 'should throw ArgumentError' do
    expect{ EventTableModel.new({}) }.to raise_error(ArgumentError)
    expect{ EventTableModel.new({'hostname' => 'test'}) }.to raise_error(ArgumentError)
  end
end

describe EventTableModel, 'when right argument' do
  before do
    mysql_info = { 'hostname' => 'test', 'username' => 'test', 'password' => 'test', 'dbname' => 'test_db' }
    @model = EventTableModel.new(mysql_info)
  end

  it 'should throw ArgumentError' do
    expect{ @model.add_data({}) }.to raise_error(ArgumentError) 
  end

  it 'should add record' do
    @model.add_data({'title' => 'test'})
    expect(@model.records[0]['title']).to eq 'test'
  end
end

