
local gcmd = require "resty.gm.cmd"


os.execute('mkdir -p '..string.match(ngx.var.thumbnail_filepath, "^.*/"))

local g = gcmd:new()

g:D(true)
g:gm_format(ngx.var.request_filepath , ngx.var.thumbnail_filepath, 0)

g:run()
ngx.req.set_uri('/thumbnail'..ngx.var.uri, true);

-- test

-- ngx.header.content_type ="text/plain";
-- ngx.say("hello world! ".."\r\n")
-- ngx.say(ngx.var.request_filepath.."\r\n")
-- ngx.say(ngx.var.thumbnail_filepath.."\r\n")