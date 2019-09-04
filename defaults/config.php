<?php
    $http_path = "/showdown-manager"; // Showdown Manager 설치되어 있는 디렉토리 ex) /volume1/web/showdown-manager
    $client_path = "/showdown"; // Showdown 설치되어 있는 디렉토리 ex) /volume1/showdown

    $showdown_url = "localhost"; // Shodown이 설치되어 있는 IP, 같은 서버일 경우 localhost ex) localhost
    $showdown_port = 4040; // Showdown이 동작하는 Port, Showdown config.properties 참조 ex) 4040

    $start_page = 2; // 메뉴 번호 1~10

    // Showdown Manager 접속 ID/Passwd 설정. 미설정시 인증 Pass
    $manager_id = '';
    $manager_passwd = '';

    // 시놀로지의 경우 폴더 권한에 자식 폴더 및 파일 포함 http 권한 설정 필요
    // Linux 기반사 용자의 경우 showdown의 실행 권한을 showdown-manager web 실행 권한(ex. http)과 showdown 파일들의 소유자를 같이 맞출 필요가 있음
    $show_log_menu = 'Y';

    // Web UI Theme 선택.
    $manager_theme = 'black'; // default , black

    ## 이 이하는 수정하지 마세요.
    $showdown_min_ver = 'v1.54'; // Showdown 필요 버전
    $showdown_manager_ver = 'v1.0.1'; // Showdown Manager 버전

    ## Docker용 환경 설정
    if ( trim($_SERVER['WEB_DOCUMENT_ROOT']) != '' ) $http_path = trim($_SERVER['WEB_DOCUMENT_ROOT']);
    if ( trim($_SERVER['SHOWDOWN_PATH']) != '') $client_path = trim($_SERVER['SHOWDOWN_PATH']);
    if ( trim($_SERVER['SHOWDOWN_START_PAGE']) != '' ) $start_page = trim($_SERVER['SHOWDOWN_START_PAGE']);
    if ( trim($_SERVER['SHOWDOWN_LOG_VIEW']) != '' ) $show_log_menu = trim($_SERVER['SHOWDOWN_LOG_VIEW']);

    if ( trim($_SERVER['SHOWDOWN_MANAGER_THEME']) != '' ) $manager_theme = trim($_SERVER['SHOWDOWN_MANAGER_THEME']);
    if ( trim($_SERVER['SHOWDOWN_MANAGER_ID']) != '' ) $manager_id = trim($_SERVER['SHOWDOWN_MANAGER_ID']);
    if ( trim($_SERVER['SHOWDOWN_MANAGER_PASSWD']) != '' ) $manager_passwd = trim($_SERVER['SHOWDOWN_MANAGER_PASSWD']);

    if ( trim($_SERVER['SHOWDOWN_URL']) != '' ) $showdown_url = trim($_SERVER['SHOWDOWN_URL']);
    if ( trim($_SERVER['SHOWDOWN_PORT']) != '' ) $showdown_port = trim($_SERVER['SHOWDOWN_PORT']);
