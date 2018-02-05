
local gcmd = require "resty.gm.cmd"


os.execute('mkdir -p '..string.match(ngx.var.thumbnail_filepath, "^.*/"))

local g = gcmd:new()
g:D(true)
local q = tonumber(ngx.var.quality)
if  q > 100 then
	g:gm_quality(ngx.var.request_filepath , ngx.var.thumbnail_filepath, 90)
else 
	g:gm_quality(ngx.var.request_filepath , ngx.var.thumbnail_filepath, q)
end

g:run()
ngx.req.set_uri('/thumbnail'..ngx.var.uri, true);

-- ngx.header.content_type ="text/plain";
-- ngx.say("hello world! ".."\r\n")
-- ngx.say(ngx.var.request_filepath.."\r\n")
-- ngx.say(ngx.var.thumbnail_filepath.."\r\n")
-- ngx.say(ngx.var.quality..q.."\r\n")