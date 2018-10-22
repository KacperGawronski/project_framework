/*
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


#include <sys/socket.h>
#include <netdb.h>
#include <pthread.h>
#include <string.h>
#include <semaphore.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include "worker/worker.h"
#include "worker/worker_arg.h"
#include <signal.h>

#include <lua5.3/lua.h>
#include <lua5.3/lualib.h>
#include <lua5.3/lauxlib.h>


static int s;

void SIG_handler(int sig){
	close(s);
	exit(0);
}


#define MAX_THREADS_NUMBER 100

sem_t counter_sem;

int main(void){
	struct addrinfo hints;
	struct addrinfo *result,*rp;
	struct sockaddr tmp_sockaddr;
	struct worker_arg *tmp;
	socklen_t sockaddr_len;
	int i;
	pthread_t threads_array[MAX_THREADS_NUMBER];

	/*signals*/
	signal(SIGTERM,SIG_handler);
	signal(SIGINT,SIG_handler);


	memset(&hints,0,sizeof(hints));
	hints.ai_family=AF_INET;
	hints.ai_socktype=SOCK_STREAM;
	hints.ai_flags=AI_PASSIVE;
	if(getaddrinfo(NULL,"9090",&hints,&result)==-1){;
		return 1;
	}
	for(rp=result;rp!=NULL;rp=rp->ai_next){
		if((s=socket(rp->ai_family,rp->ai_socktype,rp->ai_protocol))==-1){perror("Socket");continue;}

		if(!bind(s,rp->ai_addr,rp->ai_addrlen))break;
		perror("Bind");
		close(s);
	}

	if(rp==NULL){
		freeaddrinfo(result);
		return 2;
	}
	freeaddrinfo(result);
	
	if(listen(s,MAX_THREADS_NUMBER))return 5;


	if(sem_init(&counter_sem,0,MAX_THREADS_NUMBER)==-1){
		return 3;
	}
	
	
	sockaddr_len=sizeof(tmp_sockaddr);
	i=0;
	while(1){
		memset(&tmp_sockaddr,0,sockaddr_len);
		tmp=malloc(sizeof(*tmp));
		if(tmp==NULL){perror("Malloc:"); return 6;}
		if((tmp->s=accept(s,&tmp_sockaddr,&sockaddr_len))<0)return 4;
		sem_wait(&counter_sem);
		pthread_create(&threads_array[++i%MAX_THREADS_NUMBER],NULL,worker,tmp);
		tmp=NULL;
	}
	return 0;
}
