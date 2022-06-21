#!/bin/sh

while getopts ":c:o:" opt; do
  case $opt in
    c) benchmark_file="$OPTARG"
    ;;
    o) out_file="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

printf "Saved stats, config, and cmdlogs of %s to results folder.\n" "$out_file"

cp -i "m5out/stats.txt" "../results/stats_$out_file.txt"
cp -i "m5out/config.json" "../results/config_$out_file.json"
cp -i "cmdlog_$out_file.txt" "../results/cmdlog_$out_file.txt"