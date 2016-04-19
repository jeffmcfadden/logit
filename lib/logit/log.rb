module Logit

  class Log
    
    attr_accessor :debug
    attr_accessor :verbose
    
    attr_accessor :filename
    
    attr_accessor :file_data
    attr_accessor :data_five_minute_intervals    
    attr_accessor :data_thirty_minute_intervals  
    attr_accessor :data_two_hour_intervals          
    attr_accessor :data_one_day_intervals        
                                                  
    def initialize( options = {} )
      self.filename = options[:filename]
      self.debug    = options[:debug]
      self.verbose  = options[:verbose]
      
      self.debug   ||= false
      self.verbose ||= false
      
      self.verbose = true if self.debug == true
      
      if self.filename.nil? || self.filename.strip == ""
        raise "No file specified!"
      end
      
      self
    end
    
    def create_empty_file
      puts "Creating empty file" if verbose
      
      data = ""
  
      start = (Time.now.to_i / 300.0).to_i * 300
      start -= 300 #Always start at least 600 seconds ago so we don't skip this new entry.

      t = start
      600.times do
        data += "#{t} 0\n"
        t -= 300
      end
  
      600.times do
        data += "#{t} 0\n"
        t -= 1800
      end
  
      600.times do
        data += "#{t} 0\n"
        t -= 7200
      end
  
      700.times do
        data += "#{t} 0\n"
        t -= 86400
      end
  
      file_data = data
      File.open(filename, 'w') {|f| f.write(data) }
      
      self
    end
    
    def load
      puts "Loading file #{filename}" if verbose
      
      if File.exist?( self.filename )
        self.file_data = File.open( self.filename ).read
      else
        create_empty_file
      end
      
      lines = self.file_data.split( "\n" )
      self.data_five_minute_intervals   = lines[0..599]
      self.data_thirty_minute_intervals = lines[600..1199]
      self.data_two_hour_intervals      = lines[1200..1799]    
      self.data_one_day_intervals       = lines[1800..2499]
      
      self
    end
    
    def update_file_data
      puts "update_file_data" if debug
      
      lines = data_five_minute_intervals + data_thirty_minute_intervals + data_two_hour_intervals + data_one_day_intervals
  
      self.file_data = lines.join( "\n" )
    end
    
    def save
      puts "Saving file #{filename}" if verbose
  
      File.open(filename, 'w') {|f| f.write( self.file_data ) }
      
      self
    end
    
    def last_timestamp
      file_data.split( "\n" ).first.split( " " ).first.to_i
    end
    
    def last_value
      file_data.split( "\n" ).first.split( " " ).last.to_f
    end
    
    def log_value( v )
      t = Time.now.to_i
      
      if t - last_timestamp < 300
        # Too soon, don't log
        puts "Too soon. Skipping logging." if verbose
        return self
      end
      
      if t - last_timestamp >= 600
        missed_values_count = ((t - last_timestamp) / 300.0).to_i - 1
        
        if missed_values_count > 0
          puts "Missed #{missed_values_count} entries. Pushing 0s for those." if debug
        end
        
        missed_values_count.times do
          push_log_value( 0 )
        end
      end
        
      puts "Logging the latest value (#{v})." if verbose
      push_log_value( v )
      
      self
    end
    
    def push_log_value( v )
      
      puts "push_log_value( #{v} )" if debug
      
      logtime = last_timestamp.to_i + 300
      new_line = "#{logtime} #{v}"
      
      puts "    logtime: #{logtime}" if debug
      
      data_five_minute_intervals.unshift( new_line )
      data_five_minute_intervals.pop
      
      if logtime % 1800 == 0
        rotate_thirty_minute_logs
      end
  
      if logtime % 7200 == 0
        rotate_two_hour_logs
      end
  
      if logtime % 86400 == 0
        rotate_one_day_logs
      end
      
      update_file_data
    end
        
    def rotate_thirty_minute_logs
      puts "Rotating the 30m intervals"  if debug
  
      # Shift the 30s
      new_thirty_minute_value = data_five_minute_intervals[595..599].collect{ |i| i.split( " " ).last.to_f }.inject(:+) / 5.0
      new_thirty_minute_timestamp = data_thirty_minute_intervals.first.split( " " ).first.to_i + 1800
  
      data_thirty_minute_intervals.unshift( "#{new_thirty_minute_timestamp} #{new_thirty_minute_value}")
      data_thirty_minute_intervals.pop
    end
    
    def rotate_two_hour_logs
      puts "Rotating the 2h intervals"  if debug
  
      # Shift the 2hs
      new_two_hour_value = data_thirty_minute_intervals[595..599].collect{ |i| i.split( " " ).last.to_f }.inject(:+) / 5.0
      new_two_hour_timestamp = data_two_hour_intervals.first.split( " " ).first.to_i + 7200
  
      data_two_hour_intervals.unshift( "#{new_two_hour_timestamp} #{new_two_hour_value}")
      data_two_hour_intervals.pop
    end
    
    def rotate_one_day_logs
      puts "Rotating the 1d intervals"  if debug
  
      # Shift the 1ds
      new_one_day_value = data_two_hour_intervals[595..599].collect{ |i| i.split( " " ).last.to_f }.inject(:+) / 5.0
      new_one_day_timestamp = data_one_day_intervals.first.split( " " ).first.to_i + 86400
  
      data_one_day_intervals.unshift( "#{new_one_day_timestamp} #{new_one_day_value}")
      data_one_day_intervals.pop if data_one_day_intervals.size > 700
    end
    
  end

end