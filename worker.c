/*This file is part of Lua Webserver.

Lua Webserver is free software: you can redistribute it and/or
modify it under the terms of the GNU General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Lua Webserver is distributed in the hope that it will be
useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Lua Webserver. If not, see
https://www.gnu.org/licenses/
*/

#include "worker.h"
#include <pthread.h>
#include <sys/socket.h>
#include <unistd.h>
#include "stack.h"
#include <semaphore.h>
#include <string.h>
#include <stdio.h>

#include "mariadb_connector.h"

#include <lua5.3/lua.h>
#include <lua5.3/lualib.h>
#include <lua5.3/lauxlib.h>


#define HTTP_REQUEST_SIZE 10240

void *worker(void *arg){
	extern sem_t counter_sem;
	char buffer[HTTP_REQUEST_SIZE];
	int n,i;
	int tmp_s;
	
	const char *response;
	
		lua_State *L;
		/*STARTING Lua interpreter*/
		L=luaL_newstate();
		luaL_openlibs(L);
		
		/*initializing database connection function*/
		lua_pushcfunction(L,mariadb_execute_select);
		lua_setglobal(L,"mariadb_execute_select");
		lua_pushnil(L);
		/*loading app*/
		tmp_s=luaL_dofile(L,"app/app.lua");
		if(tmp_s){perror("Error loading script:");}

	memset(buffer,HTTP_REQUEST_SIZE,sizeof(char));
	buffer[HTTP_REQUEST_SIZE-1]='\0';
	n=recv(((struct stack_element *)arg)->s,buffer,HTTP_REQUEST_SIZE-1,MSG_DONTWAIT)
		if(!strncmp(buffer,"GET",3)){
			
			lua_getglobal(L,"process_request");
			lua_pushstring(L,buffer);
			lua_call(L,1,1);
			lua_setglobal(L,"current_state_function");
			while(lua_getglobal(L,"current_state_function")&&(!lua_isnil(L,-1))&&LUA_YIELD==lua_resume(L,NULL,0)){
				response=lua_tostring(L,-1);
				send(((struct stack_element *)arg)->s,response,strlen(response),MSG_DONTWAIT);
				lua_pop(L,1);
			}
		}
		
	lua_close(L);
	close(((struct stack_element*)arg)->s);
	stack_push((struct stack_element *)arg);
	sem_post(&counter_sem);
	return NULL;
}
