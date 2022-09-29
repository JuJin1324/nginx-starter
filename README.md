# nginx-starter

## Docker
### 실행
> `docker-compose up -d`  

### bash 접속
> `docker exec -it nginx-starter /bin/bash`

## nginx 기본
### worker process 갯수 확인
> `ps aux --forest | grep nginx`  

### index.html
> 위치: `/usr/share/nginx/html/index.html`  



## config
### 위치
> `/etc/nginx/nginx.conf`

### 문법 오류 검사
> config 파일 : `nginx -t`

### location
> `/etc/nginx/nginx.conf` 에 include 되는 conf 로 `/etc/nginx/conf.d` 에 존재하는 conf   
> 기본 Prefix 설정
> ```nginx
> server {
>   listen *:82;
>   server_name helloworld.com;
>   
>   location / {
>       return 200 "hellworld\n";
>   }
> }
> ```
> 기본 location 설정의 경우 Prefix 설정으로 location 설정 경로가 앞에 포함되어 있으면 포워딩 해준다.   
> 예를 들어서 `curl helloworld.com:82/` 의 경우나 `curl helloworld.com:82/aaaa` 의 경우 모두 맨 앞 경로에 `/` 가 
> 들어갔음으로 `helloworld\n` 가 표시된다.
> 
> Exact Match 설정
> ```nginx
> server {
>   listen *:82;
>   server_name helloworld.com;
>   
>   location = / {
>       return 200 "hellworld\n";
>   }
> }
> ```
> Exact Match 설정의 경우 정확히 매칭되어야 포워딩 해준다.  
> 예를 들어서 `curl helloworld.com:82/` 의 경우에만 `helloworld\n` 가 리턴되며, 
> `curl helloworld.com:82/aaaa` 의 경우 경로가 정확히 `/`에 일치하지 않음으로 `Not Found` 페이지가 리턴된다.  


