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

#include "menu.h"
#include <dirent.h>
#include <string.h>
#include <stdio.h>

static void make_tree(lua_State *L, char *path,int *strings_amount){
	char cur_item[256];
	char cur_name[128];
	DIR *dir;
	struct dirent *entry;
	int l;
	
	
	if ((dir = opendir(path)) != NULL){
		while ((entry = readdir(dir)) != NULL){
			switch(entry->d_type){
				case DT_REG:
					if(!strcmp(".lua",&(entry->d_name[strlen(entry->d_name)-4]))){
						strncpy(cur_name,entry->d_name,strlen(entry->d_name)-4);
						cur_name[strlen(entry->d_name)-4]='\0';
						snprintf(cur_item,255,"<li class=\"menu_button\"><a class=\"menu_link\" href=\"page?%s\">%s</a></li>",cur_name,cur_name);
						lua_pushnumber(L,++(*strings_amount));
						lua_pushstring(L,cur_item);
						lua_settable(L,-3);
					}
					break;
			}
		}	
	closedir(dir);
	}

}

int generate_menu(lua_State *L){
	int strings_amount=0;
	const char *str;
	str=lua_tostring(L,-1);
	lua_pop(L,1);
	lua_newtable(L);
	
	++strings_amount;
	lua_pushnumber(L,strings_amount);
	lua_pushstring(L,"<menu class=\"main_menu\"><ul class=\"menu_list\">");
	lua_settable(L,-3);
	
	make_tree(L,str,&strings_amount);
	++strings_amount;
	lua_pushnumber(L,strings_amount);
	lua_pushstring(L,"</menu></ul>");
	lua_settable(L,-3);
	
    return 1;
}
