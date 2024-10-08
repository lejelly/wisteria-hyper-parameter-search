#!/bin/bash

# 実行間隔（秒）
INTERVAL=10

# ハイパラ２つのグリッドサーチの場合
for param1 in $(seq 0.0 0.1 1.0); do
  for param2 in $(seq 0.0 0.1 1.0); do
    
    # ジョブ数が12未満になるまで待機
    while true; do
      # JOB_ID の行数をカウントしてジョブ数を取得
      job_count=$(pjstat | grep -c "^[0-9]")

      echo "現在のジョブ数: $job_count"

      # ジョブ数が12未満であれば新しいジョブを送信
      if [ "$job_count" -lt 12 ]; then
        echo "ジョブ数が12未満です。新しいジョブを送信します。"
        break
      else
        echo "ジョブ数が12以上のため、新しいジョブは待機します。"
      fi

      # 指定した間隔だけ待機
      sleep $INTERVAL
    done

    # 実行コマンド(-xで引数を渡せる)
    pjsub -g YOURGROUP -x param1=${param1},param2=${param2} run.sh 
  done
done
