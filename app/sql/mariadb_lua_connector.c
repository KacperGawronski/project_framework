#include <mariadb/mysql.h>

#include <lua5.3/lua.h>
#include <lua5.3/lualib.h>
#include <lua5.3/lauxlib.h>

#define HOST "localhost"
#define USER "exampleuser"
#define PASS "123"
#define DATABASE "employees"
#define PORT 3306
#define SOCKET NULL
#define OPTIONS 0

int main(void){
	MYSQL *conn;
	MYSQL_RES *res;
	MYSQL_ROW row;
	int n_fields,i;
	conn=mysql_init(NULL);
	if(!mysql_real_connect(conn,HOST,USER,PASS,DATABASE,PORT,SOCKET,OPTIONS)){
		return 1;
	}
	if(mysql_query(conn,"SELECT emp_no, first_name,last_name,birth_date FROM employees LIMIT 10;")){
		return 2;
	}
	res=mysql_use_result(conn);
	n_fields=mysql_num_fields(res);
	
	while(row=mysql_fetch_row(res)){
		printf("%s %s %s %s\n",row[0],row[1],row[2],row[3]);
	}
	mysql_free_result(res);
	mysql_close(conn);

	return 0;
}
