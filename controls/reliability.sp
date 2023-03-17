locals {
  reliability_common_tags = merge(local.aws_well_architected_common_tags, {
    benchmark   = "reliability"
  })
}

benchmark "reliability_pillar" {
  title         = "Reliability Pillar"
  description   = "TO-DO"
  children = [
    benchmark.reliability_pillar_1
  ]

  tags = merge(local.reliability_common_tags, {
    type = "Benchmark"
  })
}

benchmark "reliability_pillar_1" {
  title         = "REL-1"
  description   = "TO-DO"
  children = [
    control.lambda_function_dead_letter_queue_configured
  ]

  tags = merge(local.reliability_common_tags, {
    type = "Benchmark"
  })
}
