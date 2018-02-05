
local gcmd = require "resty.gm.cmd"
local gtclip = require "resty.gm.tclip"


local s_url = 'http://p10.yokacdn.com'
local curl_path = ngx.var.document_root..'/curl'..ngx.var.req_image
local dest_url = s_url..ngx.var.req_image

os.execute('mkdir -p '..string.match(curl_path, "^.*/") )
os.execute('mkdir -p '..string.match(ngx.var.thumbnail_filepath, "^.*/"))


local gt = gtclip:new()
local gc = gcmd:new()

gt:D(true)
gc:D(true)

gc:download(curl_path, dest_url)

if ngx.var.dest_ext == "webp" or ngx.var.dest_ext == "gif"  then

	local tmp = ngx.var.document_root.."/thumbnail"..ngx.var.req_image.."_t"..ngx.var.width.."x"..ngx.var.height.."."..ngx.var.source_ext
	
	local file, err = io.open(tmp)
	
	if err then
		gt:convert(curl_path , tmp, ngx.var.width, ngx.var.height)
		gt:run()
	else
		file:close()
	end


	local quality = tonumber(ngx.var.quality)
	gc:gm_format(tmp, ngx.var.thumbnail_filepath, quality)
	gc:run()

else
	gt:convert(curl_path , ngx.var.thumbnail_filepath, ngx.var.width, ngx.var.height)
	gt:run()
end
ngx.req.set_uri('/thumbnail'..ngx.var.uri, true);


-- test

-- ngx.header.content_type ="text/plain";
-- ngx.say("hello world! ".."\r\n")
-- ngx.say(ngx.var.request_filepath.."\r\n")
-- ngx.say(ngx.var.req_image.."\r\n")
-- ngx.say(ngx.var.uri.."\r\n")
-- ngx.say(ngx.var.document_root..ngx.var.uri.."\r\n")
-- ngx.say(curl_path.."\r\n")
-- ngx.say('curl -o '..curl_path..' '..dest_url.."\r\n")
-- ngx.say(ngx.var.thumbnail_filepath.."\r\n")