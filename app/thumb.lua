
local gcmd = require "resty.gm.cmd"


os.execute('mkdir -p '..string.match(ngx.var.thumbnail_filepath, "^.*/"))

local g = gcmd:new()
g:D(true)
g:log("thumbnail")



local crop_type = '!'
local itype = tonumber(ngx.var.crop_type)

if itype == 1 then
	crop_type = ''
elseif itype == 2 then
	crop_type = '_'
elseif itype == 3 then
	crop_type = '!'
elseif itype == 4 then
	crop_type = '^'
elseif itype == 5 then
	crop_type = '>'
elseif itype == 6 then
	crop_type = '$'
else
	crop_type = ''
end

local quality = tonumber(ngx.var.quality)

if quality > 100 then
	quality = 90
end

g:gm_thumbnail(ngx.var.request_filepath , ngx.var.thumbnail_filepath, ngx.var.width, ngx.var.height, crop_type, quality)
g:run()

ngx.req.set_uri('/thumbnail'..ngx.var.uri, true)

-- test

-- ngx.header.content_type ="text/plain";
-- ngx.say("hello world! ".."\r\n")
-- ngx.say(ngx.var.request_filepath.."\r\n")
-- ngx.say(ngx.var.thumbnail_filepath.."\r\n")
-- ngx.say(ngx.var.crop_type.."\r\n")
-- ngx.say(ngx.var.uri.."\r\n")