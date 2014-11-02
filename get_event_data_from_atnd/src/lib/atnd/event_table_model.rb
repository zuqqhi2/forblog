module Atnd
  
  class EventTableModel
    require 'logger'
    require 'mysql2'

    attr_reader :records

    def initialize(mysql_info)
      raise ArgumentError, 'irregular event_data' if mysql_info['hostname'].nil?
      raise ArgumentError, 'irregular event_data' if mysql_info['username'].nil?
      raise ArgumentError, 'irregular event_data' if mysql_info['password'].nil?
      raise ArgumentError, 'irregular event_data' if mysql_info['dbname'].nil?
      
      @client = Mysql2::Client.new(:host => mysql_info['hostname'], :username => mysql_info['username'], :password => mysql_info['password'], :database => mysql_info['dbname'])

      @records = []
    end

    def add_data(event_data)
      raise ArgumentError, 'irregular event_data' if event_data['title'].nil?

      fields = {}
      fields['title']                  = event_data['title'].gsub(/"/,'\"')
      fields['summary']                = event_data['catch'].gsub(/"/,'\"')            if !event_data['catch'].nil?
      fields['description']            = event_data['description'].gsub(/"/,'\"')      if !event_data['description'].nil?
      fields['event_url']              = event_data['event_url']                       if !event_data['event_url'].nil?
      fields['event_member_url']       = event_data['url']                             if !event_data['url'].nil?
      fields['event_start_time']       = event_data['started_at']                      if !event_data['started_at'].nil?
      fields['event_end_time']         = event_data['ended_at']                        if !event_data['ended_at'].nil?
      fields['event_updated_time']     = event_data['updated_at']                      if !event_data['updated_at'].nil?
      fields['attendance_limit']       = event_data['limit']                           if !event_data['limit'].nil?
      fields['attendance_people']      = event_data['accepted']                        if !event_data['accepted'].nil?
      fields['waiting_people']         = event_data['waiting']                         if !event_data['waiting'].nil?
      fields['address']                = event_data['address'].gsub(/"/,'\"')          if !event_data['address'].nil?
      fields['place']                  = event_data['place'].gsub(/"/,'\"')            if !event_data['place'].nil?
      fields['lattitude']              = event_data['lat']                             if !event_data['lat'].nil?
      fields['longitude']              = event_data['lon']                             if !event_data['lon'].nil?
      fields['event_owner_id']         = event_data['owner_id']                        if !event_data['owner_id'].nil?
      fields['event_owner_name']       = event_data['owner_nickname'].gsub(/"/,'\"')   if !event_data['owner_nickname'].nil?
      fields['event_owner_twitter_id'] = event_data['owner_twitter_id'].gsub(/"/,'\"') if !event_data['owner_twitter_id'].nil?
      fields['source_site']            = 'atnd'
      fields['created_time']           = Time.now.strftime('%Y-%m-%d %H:%M:%S')

      @records.push(fields)
    end

    def insert()
      @records.map { |rec| @client.query('INSERT INTO event_info (' + rec.keys.join(',') + ') VALUES ("' + rec.values.join('","') + '")') };
    end
  end
end 
