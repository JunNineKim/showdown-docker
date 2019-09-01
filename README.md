# Introduction
Transmission과 Showdown, Showdown Web Manager를 동시에 설치하는 도커 컨테이너입니다.  
Showdown과 Showdown Web Manager는 내장되어 있지 않으므로, 원 제작자의 배포처에서 다운로드 받으시기 바랍니다.

# Requirements
- Showdown (1.55) (https://iodides.tistory.com/category/ShowDown)
- Showdown-manager (1.0.0) (https://github.com/kumryung/showdown-manager)

# Usage
```
docker run -d \
  --name=showdown \
  -e PUID=1000 \
  -e PGID=1000 \
  -p 80:80 \
  -p 4040:4040 \
  -p 9091:9091 \
  -p 51413:51413 \
  -p 51413:51413/udp \
  -v {path to transmission downloads and watch}:/transmission \
  -v {path to showdown}:/showdown \
  -v {path to showdown-manager}:/showdown-manager \
  -v {path to output files}:/output \
  --restart unless-stopped \
  banyazavi/showdown:amd64
```

- banyazavi/showdown 뒤의 태그는 사용하려는 시스템의 아키텍처에 맞추어야 합니다.  
  amd64(데스크탑용), arm(임베디드용)을 기본 제공하고 있습니다.  
  제공하지 않는 아키텍처의 경우 소스코드를 다운받아 직접 빌드하여 사용해야 합니다.
- -v 옵션으로 연결된 폴더와 내부 파일이 -e에서 설정한 PUID/PGID의 소유로 변경되므로, 적절한 유저와 그룹을 할당해야 합니다.

# Parameters
Parameter|Function
---|---
-e PUID|리눅스 유저 ID (연결된 볼륨의 소유자)
-e PGID|리눅스 그룹 ID (연결된 볼륨의 소유그룹)
-p 80|Showdown Manager 웹 접속 포트
-p 4040|Showdown 접속 포트 (도커 외부에서 CLI 접속할 경우)
-p 9091|Transmission RPC 접속 포트
-p 51413|Transmission 리스닝 포트
-p 51413/udp|Transmission 리스닝 포트 (UDP)
-v /transmission|Transmission 다운로드 폴더 (complete, imcomplete, watch)
-v /showdown|Showdown 폴더
-v /showdown-manager|Showdown Manager 폴더
-v /output|Showdown에 의해 다운로드 완료된 파일이 옮겨지는 폴더

# Showdown config
Showdown 내의 **config.properties** 파일의 다음 항목을 수정해야 합니다.  
아래 링크의 config.properties 기본 설정 파일을 다운로드하여 Showdown 내에 붙여 넣으셔도 됩니다.  
**[# config.properties 기본 설정](https://raw.githubusercontent.com/banyazavi/showdown-docker/master/defaults/config.properties)**

```
[server]
server_ip = localhost
server_port = 4040

-- 중략 --

[transmission]
transmission_url=http://localhost:9091/transmission/rpc/
transmission_username=banyazavi
transmission_password=banyazavi

-- 중략 --

[move]
file_move=Y
file_move_season_folder=Y # 변경 가능
drama_file_move_base_path=/output/드라마_한국/
enter_file_move_base_path=/output/예능/
tv_file_move_base_path=/output/TV/

-- 후략 --
```

후술할 Transmission setting을 변경하는 경우,  
[transmission] 이하의 정보도 맞추어 바꿔주시기 바랍니다.

[move] 설정의 /output/ 이하 경로는 수정 가능합니다.  
그리고 실제 매핑될 /output/ 이하 경로에 동명의 폴더를 만들어 주어야 합니다.

# Showdown-manager config
Showdown-manager의 **config.php** 파일의 다음 항목 또한 바뀌어야 합니다.  
이것 역시 아래 링크의 config.php 기본 설정 파일을 다운로드하여 Showdown-manager 내에 붙여 넣으셔도 됩니다.  
**[# config.php 기본 설정](https://raw.githubusercontent.com/banyazavi/showdown-docker/master/defaults/config.php)**

```
    $http_path = "/showdown-manager";
    $client_path = "/showdown";

    $showdown_url = "localhost";
    $showdown_port = 4040;

-- 후략 --
```

# Default setting of Transmission
**/transmission/settings.json** 파일이 존재할 경우, 해당 파일의 설정으로 Transmission을 실행합니다.  
기본 설정은 아래와 같습니다. 아래 링크의 파일을 다운로드할 수도 있습니다.  
**[# settings.json 기본 설정](https://raw.githubusercontent.com/banyazavi/showdown-docker/master/defaults/settings.json)**

```
{
    "alt-speed-down": 50,
    "alt-speed-enabled": false,
    "alt-speed-time-begin": 540,
    "alt-speed-time-day": 127,
    "alt-speed-time-enabled": false,
    "alt-speed-time-end": 1020,
    "alt-speed-up": 50,
    "bind-address-ipv4": "0.0.0.0",
    "bind-address-ipv6": "::",
    "blocklist-enabled": false,
    "blocklist-url": "http://www.example.com/blocklist",
    "cache-size-mb": 4,
    "dht-enabled": true,
    "download-dir": "/transmission/downloads/complete",
    "download-queue-enabled": true,
    "download-queue-size": 5,
    "encryption": 1,
    "idle-seeding-limit": 30,
    "idle-seeding-limit-enabled": false,
    "incomplete-dir": "/transmission/downloads/incomplete",
    "incomplete-dir-enabled": true,
    "lpd-enabled": false,
    "message-level": 2,
    "peer-congestion-algorithm": "",
    "peer-id-ttl-hours": 6,
    "peer-limit-global": 200,
    "peer-limit-per-torrent": 50,
    "peer-port": 51413,
    "peer-port-random-high": 65535,
    "peer-port-random-low": 49152,
    "peer-port-random-on-start": false,
    "peer-socket-tos": "default",
    "pex-enabled": true,
    "port-forwarding-enabled": true,
    "preallocation": 1,
    "prefetch-enabled": true,
    "queue-stalled-enabled": true,
    "queue-stalled-minutes": 30,
    "ratio-limit": 2,
    "ratio-limit-enabled": false,
    "rename-partial-files": true,
    "rpc-authentication-required": true,
    "rpc-bind-address": "0.0.0.0",
    "rpc-enabled": true,
    "rpc-host-whitelist": "",
    "rpc-host-whitelist-enabled": true,
    "rpc-password": "banyazavi",
    "rpc-port": 9091,
    "rpc-url": "/transmission/",
    "rpc-username": "banyazavi",
    "rpc-whitelist": "127.0.0.1",
    "rpc-whitelist-enabled": false,
    "scrape-paused-torrents-enabled": true,
    "script-torrent-done-enabled": false,
    "script-torrent-done-filename": "",
    "seed-queue-enabled": false,
    "seed-queue-size": 10,
    "speed-limit-down": 100,
    "speed-limit-down-enabled": false,
    "speed-limit-up": 100,
    "speed-limit-up-enabled": false,
    "start-added-torrents": true,
    "trash-original-torrent-files": false,
    "umask": 2,
    "upload-slots-per-torrent": 14,
    "utp-enabled": true,
    "watch-dir": "/transmission/watch",
    "watch-dir-enabled": true
}
```

다음 설정은 바꿔 주시는 것이 좋습니다.
- **"rpc-password"**: Transmission 비밀번호
- **"rpc-username"**: Transmission 사용자명

# Notice
- 본 이미지는 amd64 이외 아키텍처에서의 동작을 보증하지 않습니다.
- 본 이미지는 Showdown 및 Showdown Web Manager의 실행파일 및 소스를 포함하고 있지 않습니다.
