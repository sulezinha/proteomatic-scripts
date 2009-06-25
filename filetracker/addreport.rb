require 'yaml'
require 'mysql'

def addReport(report)
  report['run']['parameters'].each do |parameter|
    key = parameter.keys.first
    value = parameter.values.first
    puts "#{key}: #{value}"
  end
  report['files'].each do |file|
    unless file['basename']
      puts "Error: Obsolete report format."
      exit 1
    end
    
    identifier = "basename#{file['basename']}"
    identifier = "md5#{file['md5']}" if file['md5']
    puts identifier
  end
end

  puts "-----------------------"
  print report['run']["user"].strip, "-", report['run']["script_title"].strip, "-", report['run']["host"].strip, "-", report['run']["uri"].strip, "-", 
  report['run']["version"].strip, "-", report['run']["start_time"].strip, "-", report['run']["end_time"].strip "\n"

  puts "-----------------------"
  puts
  
  user = report['run']["user"].strip
  title = report ['run']["script_title"].strip
  host = report['run']["host"].strip
  uri = report['run']["uri"].strip
  version = report['run']["version"].strip
  start_time = report['run']["start_time"].strip
  end_time = report['run']["end_time"].strip
  
  conn.query( 
    "INSERT INTO `runs` (user, title, host, uri, version, start_time, end_time ) VALUES ( '#{user}', '#{title}', '#{host}', '#{uri}', '#{version}', '#{start_time}', '#{end_time}' )")
  run_id = conn.insert_id()


  conn.query( 
    "INSERT INTO `parameters`(key, value, run_id ) VALUES (#{key}, #{value}, #{run_id})")
  
  
  conn.query(
    "UPDATE `runs` SET run_id = ?, user = ?, title = ?, host = ?, uri = ?, version = ?, start_time = ?, end_time = ? WHERE run_id = ? "

  conn.query(
    "UPDATE `parameters` SET parameter_id = ?, key = ?, value = ?, run_id = ? WHERE parameter_id = ? "
  
  #filecontents
  result = conn.query( "SELECT filecontent_id FROM filecontents WHERE identifier='#{identifier}' and size = '#{size}'")
  
  filecontent_id = nil
  
  if result.num_rows == 0
    conn.query("INSERT INTO `filecontents`(identifier, size) VALUES (#{identifier}, #{size})")
    filecontent_id = conn.insert_id()
  else
    filecontent_id = result.fetch_row['filecontent_id']
  end
  
  conn.query("INSERT INTO filewithname (filecontent_id, basename, directory, ctime, mtime) VALUES (#{filecontent_id}, #{basename}, #{directory}, #{ctime}, #{mtime})")
  
  #filewithname
  result = conn.query("SELECT filewithname_id, filecontent_id, basename, directory, ctime, mtime FROM filewithname WHERE filecontent_id='#{filecontent_id}'")
  
  filewithname_id = nil
  
  if result.num_rows == 0
    conn.query("INSERT INTO `filewithname` (filecontent_id, basename, directory, ctime, mtime) VALUES (#{filecontent_id}, #{basename}, #{directory}, #{ctime}, #{mtime})")
    filewithname_id = conn.insert_id()
  else
    filewithname_id = result.fetch_row['filewithname_id']
  end
  
  conn.query("INSERT INTO `filecontents`(identifier, size) VALUES (#{identifier}, #{size})")
  
  
#Datenbankverbindung  
conn = Mysql.new("localhost" , "root" , "testen")
conn.select_db("yaml")

ARGV.each do |path|
  puts path
  report = YAML::load_file(path)
  addReport(report)
end

conn.close
