#!/usr/bin/env bash

# remember some failed commands and report on exit
error=false

show_help() {
    printf "usage: $0 [--help] [--report] [<path to package>]

Tool for running all unit and widget tests with code coverage.
(run from root of repo)

where:
    <path to package>
        run tests for package at path only
        (otherwise runs all tests)
    --report
        run a coverage report
        (requires lcov installed)
    --help
        print this message

requires code_coverage package
(install with 'pub global activate coverage')
"
    exit 1
}

# run unit and widget tests
runTests () {
  local package_dir=$1
  local repo_dir=$2
  cd $package_dir;
  if [[ -f "pubspec.yaml" ]] && [[ -d "test" ]]; then
#    flutter packages get || echo "Ignore exit(1)"
    # flutt er packages get
    # echo "run analyzer in $1"
    # flutter analyze
    # echo "run dartfmt in $1"
    # flutter dartfmt -n --set-exit-if-changed ./
    echo "running tests in $1"
    # run tests with coverage
    if grep flutter pubspec.yaml > /dev/null; then
      echo "run flutter tests"
      if [[ -f "test/all_tests.dart" ]]; then
        flutter test --coverage test/all_tests.dart || error=true
      else
        flutter test --coverage || error=true
      fi
    else
      # pure dart
      echo "run dart tests"
      runDartTestsWithCoverage  || error=true
    fi
    combineCoverage $package_dir $repo_dir
  fi
  cd - > /dev/null
}

# run tests with code coverage
runDartTestsWithCoverage () {
  local coverage_dir="coverage"
  # clear coverage directory
  rm -rf "$coverage_dir"
  mkdir "$coverage_dir"

  OBS_PORT=9292

  dart pub global run coverage:test_with_coverage
  remove_from_coverage -f coverage/lcov.info -r 'mock*'
  remove_from_coverage -f coverage/lcov.info -r '\.g\.dart$'
  echo '' >> coverage/lcov.info

}

# combine coverage into a single file for reporting
combineCoverage(){
  local package_dir=$1
  local repo_dir=$2
  escapedPath="$(echo $package_dir | sed 's/\//\\\//g')"
  if [[ -d "coverage" ]]; then
    # combine line coverage info from package tests to a common file
    sed "s/^SF:lib/SF:$escapedPath\/lib/g" coverage/lcov.info >> $repo_dir/lcov.info
    rm -rf "coverage"
  fi
}

runReport() {
    if [[ -f "lcov.info" ]] && ! [[ "$TRAVIS" ]]; then
        genhtml lcov.info -o coverage --no-function-coverage -s -p `pwd`
        open coverage/index.html
    fi
}

if ! [[ -d .git ]]; then printf "\nError: not in root of repo"; show_help; fi

case $1 in
    --help)
        show_help
        ;;
    --report)
        if ! [[ -z ${2+x} ]]; then
            printf "\nError: no extra parameters required: $2"
            show_help
        fi
        runReport
        ;;
    *)
        repo_dir=`pwd`
        # if no parameter passed
        if [[ -z $1 ]]; then
            rm -f lcov.info
            runTests '.' $repo_dir
            runTests './packages/cache' $repo_dir
            runTests './packages/communication_handler' $repo_dir
            runTests './packages/controllers' $repo_dir
            runTests './packages/models' $repo_dir
            runTests './packages/repositories' $repo_dir
            runTests './packages/services' $repo_dir
        else
            if [[ -d "$1" ]]; then
                runTests $1 $repo_dir
            else
                printf "\nError: not a directory: $1"
                show_help
            fi
        fi
        ;;
esac

#Fail the build if there was an error
if [[ "$error" = true ]] ;
then
    exit -1
fi