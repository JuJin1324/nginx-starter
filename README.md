# nginx-starter

## 개요
### 웹 서버(Web server)
> 주로 정적 콘텐츠(이미지나 정적 HTML 등)를 제공하기 위해 설계되었으며 동적 콘텐츠 요청을 식별하여 
> 앱서버(app server)로 요청을 전달하는 역할을 수행하는 서버.

### 역방향 프록시(Reverse proxy)
> 클라이언트의 요청을 받아 애플리케이션 서버로 전달하여 응답을 받은 후 다시 클라이언트에 전달하는 역할을 수행하는 서버. 
> 즉, 클라이언트와 애플리케이션 서버 사이에 존재하는 서버.

### 등장 배경
> 1999년부터는 서버 트래픽량이 높아져서 서버에 동시 연결된 커넥션이 많아졌을 때 더 이상 커넥션을 형성하지 못하는 문제가 생겼다.
> 이를 C10K 문제(Connection 10000 Problem)라고 한다.
> 
> 아파치 서버는 다음과 같은 문제점이 있었다.
> 커넥션마다 프로세스를 할당하기에 메모리 부족으로 이어짐.  
> 확장성이라는 장점이 프로세스의 리소스 양을 늘려서 무거운 프로그램이 되었음.  
> 많은 커넥션에서 요청이 들어오면 CPU 부하가 높아짐. (컨텍스트 스위칭을 많이함)  
> 즉, 수많은 동시 커넥션을 감당하기엔 아파치 서버의 구조가 적합하지 않았다.  

### 특징
> NGINX가 클라이언트와 애플리케이션 서버 사이에 있다보니 클라이언트와 직접적으로 통신을 주고 받는 것도 NGINX가 되고, 
> 애플리케이션 서버가 직접적으로 통신을 주고 받는 것도 NGINX가 되는 것이죠.
> 그렇다보니 몇가지의 큰 이점이 주어지게 됩니다.
> 
> **로드 밸런싱**   
> 요청이 많은 사이트를 운영하는 경우 하나의 서버가 아닌 여러 대의 서버를 두고 운영을 하게 됩니다.   
> 그럴 경우 특정 서버에만 요청이 몰리지 않도록 하는 역할을 NGINX가 수행하게 됩니다.  
> 
> **공격으로 부터 보호**  
> NGINX를 사용하면 웹사이트나 서비스에서 실제 서버의 IP 주소를 필요로 하지 않기 때문에 DDoS와 같은 공격이 들어와도 
> NGINX를 공격하게 되지 실제 서버에는 공격이 들어오는 것을 막을 수 있습니다.  
> 
> **캐싱**  
> NGINX는 콘텐츠를 캐싱할 수 있어 결과를 더 빠르게 응답하여 성능을 높일 수 있습니다.

### 구조
> NGINX 는 하나의 Master Process 와 다수의 Worker Process 로 구성되어 실행됩니다. Master Process는 설정 파일을 읽고,
> 유효성 검사 및 Worker Process 를 관리합니다.  
> 모든 요청은 Worker Process에서 처리합니다. NGINX 는 이벤트 기반 모델을 사용하고, 
> Worker Process 사이에 요청을 효율적으로 분배하기 위해 OS에 의존적인 메커니즘을 사용합니다.  
> Worker Process 의 개수는 설정 파일에서 정의되며, 정의된 프로세스 개수와 사용 가능한 CPU 코어 숫자에 맞게 자동으로 조정됩니다.  

### 참조사이트
> [(NGINX) NGINX란?](https://medium.com/@su_bak/nginx-nginx%EB%9E%80-cf6cf8c33245)  
> [Nginx란?](https://ssdragon.tistory.com/60)  

---

## 설치
### amazon-linux
> `sudo amazon-linux-extras install -y nginx1`

### Ubuntu
> `sudo apt install -y nginx`

---

## nginx 사용
### worker process 갯수 확인
> `ps aux --forest | grep nginx`  

### 문법 오류 검사
> config 파일 : `nginx -t`

---

## nginx.conf 
### 설명
> nginx 의 master 설정 파일이다.

### 파일 위치
> `/etc/nginx/nginx.conf`

### 옵션
> `user`: nginx 를 실행시키는 리눅스 user  
> 
> `worker_process`: 워커 프로세스의 갯수. auto 로 설정해도 되며, 직접 숫자로 갯수를 설정할 수도 있다.
> 일반적으로 서버의 코어 수 만큼 할당하는 것이 권장된다.  
> 
> `events.worker_connections`: 워커 프로세스가 처리할 수 있는 커넥션의 최대수를 의미한다.
> 최대 접속자 수 = worker_process * events.worker_connections  
> 2코어를 가진 CPU 에서의 최대 접속자 수 = 2 * 1024 = 2048   
> events.worker_connections 값을 적절히 조정하기 위해서는 먼저 시스템 코어 제한 확인 및 변경이 필요하다.  
> ```shell
> # 시스템 코어 제한 확인
> ulimit -n   
> 
> # 시스템 코어 제한 변경
> ulimit -n 1024
> ``` 
> 
> `http.keepalive_timeout`: 접속시 커넥션을 몇 초동안 유지할지에 대한 설정값. 
> 이 값이 높으면 불필요한 커넥션(접속)을 유지하기 때문에 낮은값 또는 0을 권장한다. (default=10)  
> 
> `gzip`: 응답 컨텐츠를 압축하는 옵션  
> TODO: gzip 조사
> 
> `server_tokens`: `on` 설정 시 헤더에 nginx 버전을 표시하는 기능을 한다. 보안상 `off`로 설정을 권장.  

### 무중단 conf 설정 반영
> conf 파일의 옵션들을 변경한 후 중단 없이 nginx 프로세서에 반영하기 위해서는 다음 명령어를 실행한다.  
> `sudo service nginx reload`  

### 참조사이트
> [Nginx 이해하기 및 기본 환경설정 세팅하기](https://whatisthenext.tistory.com/123)

---

## 커스텀 conf
### 커스텀 conf 파일을 위치 시킬 경로
> `/etc/nginx/nginx.conf` 에 include 되는 conf 로 `/etc/nginx/conf.d` 에 `.conf` 확장자 파일을
> 위치시킨다.

### starter.conf
> ```nginx
> upstream app {
>   server localhost:8080;
> }
> server {
> 	listen 80;
> 	server_name localhost;
> 
> 	location / {
> 		proxy_pass http://app;
> 		proxy_set_header X-Real-IP $remote_addr;
>       proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
>       proxy_set_header Host $host;
> 	}
> }
> ```
> 
> upstream 블록: origin 서버라고도 하는데, 여기서는 WAS, 웹 어플리케이션 서버를 의미하며 
> nginx는 downstream에 해당한다고 할 수 있습니다. nginx와 연결한 웹 어플리케이션 서버를 지정하는데 사용됩니다. 
> 하위에 있는 server 지시어는 연결할 웹 어플리케이션 서버의 host주소:포트를 지정합니다.

### 참조사이트
> [Nginx 개념 및 nginx.conf 설정](https://narup.tistory.com/209)

---

## 무중단 서비스 배포
### jar 파일 이동
> `./gradlew bootJar`: 애플리케이션 패키징   
> `현재 프로젝트/build/libs/nginx-starter-0.0.1-SNAPSHOT.jar` 파일을 `현재 프로젝트/docker/web` 디렉터리로 이동한다.   

### Docker - Ubuntu
> docker for macOS 에서는 cgroup version 이슈 때문에 centos7 및 amazonlinux 에서 systemctl 사용이 불가능하다.  
> centos8 은 보안취약점으로 인해서 현재 더이상 지원이 없다.(yum 을 통한 패키지 다운로드도 되지 않도록 막혔다.)  
> 어쩔 수 없는 차선으로 Ubuntu 를 통해서 nginx 테스트를 진행하였다.

### Docker 실행
> 현재 프로젝트 디렉터리 이동 후 docker/web 디렉터리로 이동한다.  
> `./stop-nginx.sh;./start-nginx.sh` 를 통해서 Docker 를 실행한다.

### 배포한 앱 실행
> `docker exec -it web-nginx-starter /bin/bash`: Docker 내부로 이동한다.  
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

## NGINX Reload
### NGINX Reload 시 기존 요청은?
> NGINX Reload 이전에 Prod1 에 보냈던 요청에 대한 응답이 오기 전에 Prod2 로 교체가 되버리면 해당 요청은 어떻게 되는가?   
> docker 실행 이후에 `/home/ec2-user/nginx-starter/scripts` 에서 `./start.sh` 를 두번 실행해서(약 2초 정도 텀을 두고 실행)
> prod1 과 prod2 를 실행한 이후에 인터넷 브라우저를 통해서 `localhost/sleep` API 호출을 하고 요청이 오기전에 
> docker 내부에서 `./switch.sh` 를 실행해서 NginX 에 연결된 애플리케이션을 prod1 -> prod2 로 변경한다.
> 결과적으로 애플리케이션이 prod1 일 때 요청했던 `localhost/sleep` API 의 요청이 정상적으로 응답한다.  
> 
> 결론: NGINX 가 reload 되더라도 기존 요청의 응답은 모두 정상 처리된다.  

