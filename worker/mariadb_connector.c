/*
Author: Kacper Gawroński

This file is part of Project Framework.

Project Framework is free software: you can redistribute it and/or
modify it under the terms of the GNU General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Project Framework is distributed in the hope that it will be
useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Project Framework. If not, see
https://www.gnu.org/licenses/
*/


#include "mariadb_connector.h"
#include <jansson.h>
#include <mariadb/mysql.h>


int mariadb_execute_select(lua_State *L){
	MYSQL *conn;
	MYSQL_RES *res;
	MYSQL_ROW row;
	MYSQL_FIELD *field_names;
	int n_fields,n_rows,i,index;
	char *s;
	json_t *main_array,*json_field,*json_row;
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
	if(res==NULL)return 0;
	n_rows=mysql_num_rows(res);
	n_fields=mysql_num_fields(res);
	field_names=mysql_fetch_fields(res);
	if(field_names==NULL)return 0;
	
	
	main_array=json_array();

	while(row=mysql_fetch_row(res)){
		json_row=json_object();
		for(i=0;i<n_fields;++i){
			json_object_set(json_row,field_names[i].name,json_string(row[i]));
		}
		json_array_append(main_array,json_row);
	}
	s=json_dumps(main_array,0);
	lua_pushstring(L,s);
	free(s);
	mysql_free_result(res);
	mysql_close(conn);
	return 1;
}

