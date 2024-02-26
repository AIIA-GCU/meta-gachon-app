# Meta Gachon

### 버전 0.1.0

<br>

# 테스트 버전 설치 방법

## Android

### 1. Android Studio (플러터용)가 있는 경우
1. 해당 repo를 로컬 컴퓨터에 clone
2. Android Studio에서 repo 열기<br>
   (열었을 때, Flutter SDK가 설정 됐는지 확인할 것)
3. 애뮬레이터 키고 실행

### 2. Android Studio가 없는 경우
1. 해당 repo에서 [build 안의 apk]을 다운로드
2. 핸드폰에서 apk 설치 진행
3. 설치가 끝나면 앱 실행

## iOS

1. 해당 repo를 로컬 컴퓨터에 clone
2. Xcode에서 build가 가능한지 확인하기
   ```shell
   sudo xcodebuild -license
   ```
3. 시뮬레이터 키고, repo의 디렉토리로 이동 후 다음 명령어 실행
   ```shell
   flutter run
   ```