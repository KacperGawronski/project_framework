#include "menu.h"
#include <dirent.h>
#include <string.h>
#include <stdio.h>

static unsigned int strings_amount=0;

static void make_tree(lua_State *L, char *path){
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
						lua_pushstring(L,cur_item);
						++strings_amount;
						lua_setfield(L,-2,strings_amount);
					}
					break;
			}
		}	
	closedir(dir);
	}

}

int generate_menu(lua_State *L){
	lua_newtable(L)
	lua_pushstring(L,"<menu class=\"main_menu\"><ul class=\"menu_list\">");
	++strings_amount;
	lua_setfield(L,-2,strings_amount);
	make_tree(L,"./pages");
	lua_pushstring(L,"</menu></ul>");
	++strings_amount;
	lua_setfield(L,-2,strings_amount);
	
    return 1;
}