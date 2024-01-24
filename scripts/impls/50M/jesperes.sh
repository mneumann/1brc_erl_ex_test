#!/usr/bin/env -S bash -x
source ./common.sh
mkdir -p "${outdir}"
data_path=$1

cd "${impldir}/jesperes/erlang_1brc"
ln -sf "${data_path}" ./measurements.txt
($branchcmd && $timecmd ./run.sh ./measurements.txt 2>&1) > "${outdir}/jesperes.50M.txt"
cd "${owd}"
