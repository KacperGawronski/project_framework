#ifndef MARIADB_CONNECTOR_H
#define MARIADB_CONNECTOR_H


#include <lua5.3/lua.h>
#include <lua5.3/lualib.h>
#include <lua5.3/lauxlib.h>


#ifndef DATABASE_DEFINES
	#define DATABASE_DEFINES
	#define HOST "localhost"
	#define USER "exampleuser"
	#define PASS "123"
	#define DATABASE "employees"
	#define PORT 3306
	#define SOCKET NULL
	#define OPTIONS 0
#endif

int mariadb_execute_select(lua_State *L);

#endif
