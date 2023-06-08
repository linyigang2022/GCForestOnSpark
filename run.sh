#!/usr/bin/env bash

# run local jar to validate the generated jar.

#spark-submit --master local[*] \
# --class examples.RandomForest.DecisionTreeExample \
# dist/gcforest-1.0-SNAPSHOT-jar-with-dependencies.jar

#spark-submit --master local[*] \
# --class examples.Yggdrasil.YggdrasilExample \
# dist/gcforest-1.0-SNAPSHOT-jar-with-dependencies.jar

spark-submit --master yarn \
  --class examples.UCI_adult.GCForestSequence \
  --executor-cores 2 \
  --num-executors 16 \
  --conf spark.dynamicAllocation.minExecutors=16 \
  --conf spark.dynamicAllocation.maxExecutors=16 \
  gcforest-1.0-SNAPSHOT-jar-with-dependencies.jar \
  --train linyigang/data/uci_adult/adult.data \
  --test linyigang/data/uci_adult/adult.test \
  --features linyigang/data/uci_adult/features
  # executors*cores
  # ① 8*4 979s
  # ② 2*2 557s

  # ③ 1*1 2945s
  # ④ 1*2 1756s
  # ⑤ 2*2 791s
  # ⑥ 4*2 1404s
  # 11 8*2 1002s

  # ⑦ 4*5 853s
  # ⑧ 8*5 764s 1210s
  # ⑨ 16*5 1314s
  # ⑩ 32*5 1299s

  # medusa002 local
  spark-submit --master local[*] \
    --class examples.UCI_adult.GCForestSequence \
    --executor-memory 4g \
    gcforest-1.0-SNAPSHOT-jar-with-dependencies.jar \
    --train linyigang/data/uci_adult/adult.data \
    --test linyigang/data/uci_adult/adult.test \
    --features linyigang/data/uci_adult/features

spark-submit --master local[*] --class examples.UCI_adult.GCForestSequence --conf spark.executor.userClassPathFirst=true --conf spark.driver.userClassPathFirst=true gcforest-1.0-SNAPSHOT-jar-with-dependencies.jar --train hdfs:///user/linyigang/data/uci_adult/adult.data --test data/uci_adult/adult.test --features data/uci_adult/features

--conf spark.dynamicAllocation.enabled=false

#   --total-executor-cores 8 \


  --executor-cores 2 \
  --num-executors 4 \
  --conf spark.dynamicAllocation.minExecutors=4 \
  --conf spark.dynamicAllocation.maxExecutors=4 \



  --conf spark.executor.userClassPathFirst=true \
  --conf spark.driver.userClassPathFirst=true \


spark-submit --master local[*] --class examples.UCI_adult.GCForestSequence --conf spark.executor.userClassPathFirst=true --conf spark.driver.userClassPathFirst=true gcforest-1.0-SNAPSHOT-jar-with-dependencies.jar

spark-submit --master local[*] --class examples.UCI_adult.GCForestSequence --jars gcforest-1.0-SNAPSHOT-jar-with-dependencies.jar gcforest-1.0-SNAPSHOT-jar-with-dependencies.jar

spark-submit --master yarn \
  --class examples.UCI_adult.GCForestSequence \
  --driver-class-path gcforest-1.0-SNAPSHOT-jar-with-dependencies.jar:path/to/your-dependency.jar\
  gcforest-1.0-SNAPSHOT-jar-with-dependencies.jar \
  --train linyigang/data/uci_adult/adult.data \
  --test linyigang/data/uci_adult/adult.test \
  --features linyigang/data/uci_adult/features