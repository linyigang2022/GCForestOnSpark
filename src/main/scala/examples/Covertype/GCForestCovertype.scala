/*
 * Copyright 2017 Authors NJU PASA BigData Laboratory. Qiu Hu. huqiu00#163.com
 */
package examples.Covertype

import org.apache.spark.ml.classification.{GCForestClassifier, RandomForestClassifier}
import datasets.{Covertype, UCI_adult}
import org.apache.spark.sql.SparkSession
import org.apache.spark.util.SizeEstimator
import org.apache.spark.ml.util.engine.Engine


object GCForestCovertype {
  def main(args: Array[String]): Unit = {

    import Utils._
    val stime = System.currentTimeMillis()
    val spark = SparkSession
      .builder()
      .appName(this.getClass.getSimpleName)
//      .master("local[*]")
      .getOrCreate()

    val parallelism = Engine.getParallelism(spark.sparkContext)
    println(s"Total Cores is $parallelism")
    spark.conf.set("spark.serializer", "org.apache.spark.serializer.KryoSerializer")
    spark.sparkContext.getConf.registerKryoClasses(Array(classOf[RandomForestClassifier]))

    trainParser.parse(args, TrainParams()).map(param => {

      spark.sparkContext.setLogLevel(param.debugLevel)
      spark.sparkContext.setCheckpointDir(param.checkpointDir)
      val output = param.model

      def getParallelism: Int = param.parallelism match {
        case p if p > 0 => param.parallelism
        case n if n < 0 => -1
        case _ => parallelism
      }

      val data = new Covertype().load_data(spark, param.trainFile, param.featuresFile, 1,
        getParallelism)

//      val test = new UCI_adult().load_data(spark, param.testFile, param.featuresFile, 1,
//        getParallelism)
      val Array(train, test) = data.randomSplit(Array(0.7, 0.3))

      if (param.idebug) println(s"Estimate trainset %.1f M,".format(SizeEstimator.estimate(train) / 1048576.0) +
        s" testset: %.1f M".format(SizeEstimator.estimate(test) / 1048576.0))


      val gcForest = new GCForestClassifier()
        .setModelPath(param.model)
        .setDataSize(param.dataSize)
        .setDataStyle(param.dataStyle)
        .setMultiScanWindow(param.multiScanWindow)
        .setRFNum(param.rfNum)
        .setCRFNum(param.crfNum)
        .setCascadeForestTreeNum(param.cascadeForestTreeNum)
        .setScanForestTreeNum(param.scanForestTreeNum)
        .setMaxIteration(param.maxIteration)
        .setMaxDepth(param.maxDepth)
        .setMaxBins(param.maxBins)
        .setMinInfoGain(param.minInfoGain)
        .setMaxMemoryInMB(param.maxMemoryInMB)
        .setCacheNodeId(param.cacheNodeId)
        .setScanForestMinInstancesPerNode(param.scanMinInsPerNode)
        .setCascadeForestMinInstancesPerNode(param.cascadeMinInsPerNode)
        .setFeatureSubsetStrategy(param.featureSubsetStrategy)
        .setCrf_featureSubsetStrategy(param.crf_featureSubsetStrategy)
        .setEarlyStoppingRounds(param.earlyStoppingRounds)
        .setIDebug(param.idebug)

      val model = gcForest.train(train, test)
      model
    })
    val totalTime = (System.currentTimeMillis() - stime) / 1000.0
    println(s"Total time for GCForest Application: $totalTime, Sleep 20s")
    Thread.sleep(20000)
    spark.stop()
  }
}

