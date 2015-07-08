#Extremely Simple API with three basic verbs. 
require 'sinatra'
require 'fileutils'
require 'tempfile'

# HTTP PUT verb creates an item on the file. Returns HTTP Code 422 if already exists. 
put '/items/:key' do
  unless File.readlines("file.out").grep(/#{params['key']}/).size != 0 then
    "Created #{params['key']}"
    open('file.out', 'a') { |f|
      f.puts "#{params['key']}\n"
    }
  else
    status 422
  end
end

# HTTP GET verb to retrieve a specific item. Returns 404 if item is not present.
get '/items/:key' do 
  unless File.readlines("file.out").grep(/#{params['key']}/).size == 0 then
    "#{params['key']} exists in file!"
  else
    status 404
  end
end

# HTTP GET verb to retrieve all the items.
get '/items' do
  file = File.open("file.out")
  contents = ""
  file.each {|line|
	    contents << line
  }
  "#{contents}"
end

# HTTP DELETE verb to remove a specific item. With a horrendous hack to recreate the file without the specific key. Returns 404 if the item is not present.
delete '/items/:key' do |k|
  unless File.readlines("file.out").grep(/#{params['key']}/).size == 0 then
    tmp = Tempfile.new("extract")
    open('file.out', 'r').each { |l| tmp << l unless l.chomp ==  params['key'] }
    tmp.close
    FileUtils.mv(tmp.path, 'file.out')
    "#{params['key']} deleted!"
  else
    status 404
  end
end
