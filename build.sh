#!/bin/bash -e

WORKDIR="$(dirname "${BASH_SOURCE[0]}")"
CHARTS_PATH="${CHARTS_PATH:-${WORKDIR}/charts}"
CHARTS_VALUES_PATH="${WORKDIR}/charts-values"

CHARTS="bblfshd bblfsh-web gitbase gitbase-web"

cat header.yaml > replicated.yaml.new

for chart in ${CHARTS}; do
helm template \
    --namespace '{{repl Namespace}}' \
    --name "replicatedcom" \
    --values "${CHARTS_VALUES_PATH}/${chart}.yaml" \
    ${CHARTS_PATH}/${chart} \
    | sed -e 's/^---/---\n# kind: scheduler-kubernetes/g' \
    >> replicated.yaml.new
done

mv replicated.yaml.new replicated.yaml
