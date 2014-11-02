require File.dirname(__FILE__) + '/spec_helper'

describe APIAction, 'when irregular argument' do
  it 'should throw ArgumentError' do
    expect{ APIAction.new('httpsss://sample.com', 'test') }.to raise_error(ArgumentError) 
    expect{ APIAction.new('http://sample.com', 'test', -10) }.to raise_error(ArgumentError) 
  end
end

describe APIAction, 'when right argument' do
  before do
    url = 'http://api.atnd.org/events/'
    keyword = '%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%9F%E3%83%B3%E3%82%B0,%E3%82%BD%E3%83%BC%E3%82%B9%E3%82%B3%E3%83%BC%E3%83%89,%E3%83%95%E3%83%AC%E3%83%BC%E3%83%A0%E3%83%AF%E3%83%BC%E3%82%AF,API,ruby,node,java,c++,haskell,scala'
    @api = APIAction.new(url, keyword, 2)
  end

  it 'should throw ArgumentError' do
    expect{ @api.get_event_json() }.to raise_error(ArgumentError) 
    expect{ @api.get_event_json(5)}.to raise_error(ArgumentError) 
  end

  it 'should return json event data' do
    data = @api.get_event_json(5, 10)
    expect(data['results_returned']).to eq 2
  end
end

