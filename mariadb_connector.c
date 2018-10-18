#include "mariadb_connector.h"
#include <mariadb/mysql.h>


int mariadb_execute_select(lua_State *L){
	MYSQL *conn;
	MYSQL_RES *res;
	MYSQL_ROW row;
	MYSQL_FIELD *field_names;
	int n_fields,n_rows,i,index;
	conn=mysql_init(NULL);
	if(!mysql_real_connect(conn,HOST,USER,PASS,DATABASE,PORT,SOCKET,OPTIONS)){
		return 0;
	}
	if(!lua_isstring(L,-1))return 0;
	if(mysql_query(conn,lua_tostring(L,-1))){
		lua_pop(L,1);
		return 0;
	}
	lua_pop(L,1);
	res=mysql_use_result(conn);
	n_rows=mysql_num_rows(res);
	n_fields=mysql_num_fields(res);
	field_names=mysql_fetch_fields(res);
	
	lua_createtable(L, 0, n_rows);
	putchar('|');
	while(row=mysql_fetch_row(res)){
		lua_createtable(L,0,n_fields);
		for(i=0;i<n_fields;++i){
			putchar('.');
			lua_pushstring(L,field_names[i].name);
			lua_pushstring(L,row[i]);
			lua_settable(L,-3);
		}
		lua_settable(L,-2);
	}
	mysql_free_result(res);
	mysql_close(conn);
	return 1;
}

