dofile("app/GET.lua")
for i in coroutine.wrap(process_request("GET / HTTP/1.1")) do print(i) end
for i in coroutine.wrap(process_request("GET /page?index HTTP/1.1")) do print(i) end
for i in coroutine.wrap(process_request("GET /page?login HTTP/1.1")) do print(i) end
