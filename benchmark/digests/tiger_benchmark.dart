// See file LICENSE for more information.

library benchmark.digests.tiger_benchmark;

import "../benchmark/digest_benchmark.dart";

main() {
  new DigestBenchmark("Tiger").report();
}
