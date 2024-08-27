#!/bin/bash -eu
# [[file:../../doc/use_cases/podcast_automation.org::run][run]]
. ./sandboxing.sh

clk command create python podcast --group --force --description "Dealing with podcasts" --body "
@podcast.command()
@option('--number', type=int, default=10, help='How many episodes to download at once')
def download(number):
    'Downloading podcasts'
    print(f'Downloading {number} episodes')
"


tryit_code () {
      clk podcast download
}

tryit_expected () {
      cat<<"EOEXPECTED"
Downloading 10 episodes
EOEXPECTED
}

diff -uBw <(tryit_code 2>&1) <(tryit_expected) || {
echo "Something went wrong when trying tryit"
exit 1
}



makeitalias_code () {
      clk alias set podcast.dwim echo 'Would do something before' , podcast download --number 'noeval:tpl:{NUMBER_TO_DOWNLOAD}' , echo 'would do something after'
}

makeitalias_expected () {
      cat<<"EOEXPECTED"
New global alias for podcast.dwim: echo Would do something before , podcast download --number tpl:{NUMBER_TO_DOWNLOAD} , echo would do something after
EOEXPECTED
}

diff -uBw <(makeitalias_code 2>&1) <(makeitalias_expected) || {
echo "Something went wrong when trying makeitalias"
exit 1
}



callit_code () {
      export NUMBER_TO_DOWNLOAD=100
      clk podcast dwim
}

callit_expected () {
      cat<<"EOEXPECTED"
Would do something before
Downloading 100 episodes
would do something after
EOEXPECTED
}

diff -uBw <(callit_code 2>&1) <(callit_expected) || {
echo "Something went wrong when trying callit"
exit 1
}
# run ends here
