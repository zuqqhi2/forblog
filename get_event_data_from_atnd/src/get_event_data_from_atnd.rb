#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'rubygems' unless defined?(gem)
here = File.dirname(__FILE__)
$LOAD_PATH << File.expand_path(File.join(here, 'lib'))

require 'logger'

require 'atnd/event_table_model'
require 'atnd/api_action'
include Atnd

logger = Logger.new(STDOUT)
url = 'http://api.atnd.org/events/'
keyword = 'ruby,haskell'

# Entry Point
begin
  logger.info('START  ALL')

  logger.info('START  Get event data from API')
  api = APIAction.new(url, keyword)
  event_data = api.get_event_json(5, 10)
  if event_data['results_returned'] == 0
    logger.warn('Nothing is result')
    exit 0
  end
  logger.info('FINISH Get event data from API')

  logger.info('START  Convert retrieved data')
  model = EventTableModel.new({'hostname' => 'test', 'username' => 'test', 'password' => 'test', 'dbname' => 'test'})
  event_data_list = event_data['events']
  event_data_list.map{|x| model.add_data(x['event'])}
  logger.info('FINISH Convert retrieved data')
  
  logger.info('START  Insert retrieved data')
  model.insert
  logger.info('FINISH Insert retrieved data')
  
  logger.info('FINISH ALL')
rescue => ex
  logger.fatal(ex)
end
