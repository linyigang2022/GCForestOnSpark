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
 --conf spark.dynamicAllocation.enabled=false \
 gcforest-1.0-SNAPSHOT-jar-with-dependencies.jar \
  --train linyigang/data/uci_adult/adult.data \
  --test linyigang/data/uci_adult/adult.test \
  --features linyigang/data/uci_adult/features

  spark-submit --master local[*] --class examples.UCI_adult.GCForestSequence gcforest-1.0-SNAPSHOT-jar-with-dependencies.jar --train data/uci_adult/adult.data --test data/uci_adult/adult.test --features data/uci_adult/features