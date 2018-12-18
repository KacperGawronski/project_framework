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
#include <string.h>
#include <stdio.h>
#include <sys/socket.h>
int mariadb_execute_select(int s,const char *SELECT){
	MYSQL *conn;
	MYSQL_RES *res;
	MYSQL_ROW row;
	MYSQL_FIELD *field_names;
	json_t *json_row;
	const char *str;
	int i,first=0;
	int n_fields;
	char buffer[1500];
	conn=mysql_init(NULL);
	if(!mysql_real_connect(conn,HOST,USER,PASS,DATABASE,PORT,SOCKET,OPTIONS)){
		return 0;
	}
	
	if(mysql_query(conn,SELECT)){
		return 0;
	}
	res=mysql_use_result(conn);
	if(res==NULL)return 0;
	n_fields=mysql_num_fields(res);
	field_names=mysql_fetch_fields(res);
	send(s,
	"HTTP/1.1 200 OK\r\nContent-Type: application/json; charset=UTF-8\r\nConnection: close()\r\n\r\n[",
	strlen("HTTP/1.1 200 OK\r\nContent-Type: application/json; charset=UTF-8\r\nConnection: close()\r\n\r\n["),0);	
	while((row=mysql_fetch_row(res))){
		json_row=json_object();
		if(first++){send(s,",{",strlen(",{"),0);}else{send(s,"{",strlen("{"),0);}
		snprintf(buffer,1499,"\"%s\":\"%s\",\"%s\":\"%s\",\"%s\":\"%s\",\"%s\":\"%s\",\"%s\":\"%s\",\"%s\":\"%s\"}",
			field_names[0].name,row[0],
			field_names[1].name,row[1],
			field_names[2].name,row[2],
			field_names[3].name,row[3],
			field_names[4].name,row[4],
			field_names[5].name,row[5]);
		send(s,buffer,strlen(buffer),0);
	}
	send(s,"]",strlen("]"),0);	
	mysql_free_result(res);
	mysql_close(conn);
	return 0;
}

