default: run

run:
    flutter run -d windows --dart-define-from-file=.env

set shell := ["powershell.exe", "-c"]