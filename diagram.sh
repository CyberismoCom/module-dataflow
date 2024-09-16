#!/bin/bash
model=$1
view=$2

die () {
    echo >&2 "$@"
    exit 1
}

scriptDir=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")

if ! [ "$#" -eq 2 ]; then
  die "2 arguments required (model and view), $# provided"
fi

if ! [ -f $scriptDir/.cards/local/graphModels/$model/model.lp ]; then
  die "The model file $scriptDir/.cards/local/graphModels/$model/model.lp does not exist."
fi

if ! [ -f $scriptDir/.cards/local/graphViews/$view/view.lp.hbs ]; then
  die "The view file $scriptDir/.cards/local/graphViews/$view/view.lp.hbs does not exist."
fi

scriptDir=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")

clingo --warn none --outf=0 -V0 --out-atomf=%s. $scriptDir/.calc/main.lp $scriptDir/.cards/local/graphModels/$model/model.lp $scriptDir/.cards/local/graphViews/$view/view.lp.hbs | head -n1  | clingraph --out=render --format=png --type=digraph
