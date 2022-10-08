# nginx-starter

## Docker
### Ubuntu
> docker for macOS 에서는 cgroup version 이슈 때문에 centos7 및 amazonlinux 에서 systemctl 사용이 불가능하다.  
> centos8 은 보안취약점으로 인해서 현재 더이상 지원이 없다.(yum 을 통한 패키지 다운로드도 되지 않도록 막혔다.)  
> 어쩔 수 없는 차선으로 Ubuntu 를 통해서 nginx 테스트를 진행하였다.  

### 실행
> `docker-compose up -d`  

### bash 접속
> `docker exec -it nginx-starter-ubuntu /bin/bash`

## nginx 기본
### worker process 갯수 확인
> `ps aux --forest | grep nginx`  

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

## 무중단 서비스 배포
### jar 파일 이동
> `./gradlew bootJar`: 애플리케이션 패키징   
> `현재 프로젝트/build/libs/nginx-starter-0.0.1-SNAPSHOT.jar` 파일을 `현재 프로젝트/docker/web` 디렉터리로 이동한다.   

### Docker 실행
> 현재 프로젝트 디렉터리 이동 후 docker 디렉터리로 이동한다.  
> `docker-compose up -d --build` 를 통해서 Docker 를 실행한다.

### 배포한 앱 실행
> `docker exec -it nginx-starter-web /bin/bash`: Docker 내부로 이동한다.  
> `cd /home/ec2-user/nginx-starter/scripts`: 스크립트 디렉터리로 이동  
> `./start.sh && ./start.sh`: 애플리케이션을 2번 실행한다. start.sh 에 정의된 문장으로 인해서 profile 이 `prod1` 과 `prod2` 인 애플리케이션이 각각 실행된다.
> Docker 밖 PC 의 브라우저에서 `http://localhost/profile` 을 통해서 현재 nginx 와 연결된 애플리케이션의 profile 을 확인한다.   
> Docker 안에서 `./switch.sh` 를 실행시켜서 nginx 와 연결된 애플리케이션을 교체한다.
> 
> 확인 부분  
> 1.`/etc/nginx/conf.d/service-url.inc` 가 기존 `set $service_url http://127.0.0.1:8087;` 에서 `set $service_url http://127.0.0.1:8088;` 로 
> 변경되었는지 확인한다.
> 
> 2.Docker 밖 PC 의 브라우저에서 `http://localhost/profile` 을 통해서 현재 nginx 와 연결된 애플리케이션의 profile 을 확인한다.  

### switch.sh
> switch.sh 파일의 내용을 보면 마지막에 `service nginx reload` 를 통해서 nginx 를 재시작하는 것을 알 수 있다.  
> 하지만 reload 의 경우 nginx 를 중단하지 않고 설정 파일 변경에 대한 적용을 하기 때문에 무중단 서비스가 가능하며 변경한 설정 파일에 오류가 있어도 
> 이전에 설정한 파일로 계속 서비스가 유지된다.  

### 참조사이트
> [Nginx 무중단 배포](https://yeonyeon.tistory.com/76)

## NginX Reload
### NginX Reload 시 기존 요청은?
> NginX Reload 이전에 Prod1 에 보냈던 요청에 대한 응답이 오기 전에 Prod2 로 교체가 되버리면 해당 요청은 어떻게 되는가?   
> docker 실행 이후에 `/home/ec2-user/nginx-starter/scripts` 에서 `./start.sh` 를 두번 실행해서(약 2초 정도 텀을 두고 실행)
> prod1 과 prod2 를 실행한 이후에 인터넷 브라우저를 통해서 `localhost/sleep` API 호출을 하고 요청이 오기전에 
> docker 내부에서 `./switch.sh` 를 실행해서 NginX 에 연결된 애플리케이션을 prod1 -> prod2 로 변경한다.
> 결과적으로 애플리케이션이 prod1 일 때 요청했던 `localhost/sleep` API 의 요청이 정상적으로 응답한다.

