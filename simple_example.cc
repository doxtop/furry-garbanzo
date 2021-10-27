#include <cstdio>
#include <string>

#include "rocksdb/db.h"
#include "rocksdb/options.h"
#include "rocksdb/sst_file_writer.h"

using namespace ROCKSDB_NAMESPACE;

int main() {
  DB* db;
  Options options;
  options.IncreaseParallelism();
  options.OptimizeLevelStyleCompaction();
  options.create_if_missing = true;

  SstFileWriter sst_file_writer(EnvOptions(), options);
  std::string file_path = "./u1.sst";

  Status s = sst_file_writer.Open(file_path);
  if (!s.ok()) {
    printf("error open file %s", file_path.c_str());
    return 1;
  }
  std::string key = "key2";
  std::string value;
// keys must be in increasing order
//  for(...){
    s = sst_file_writer.Put(key,"value2");
    if (!s.ok()) {
      printf("error put %s", key.c_str());
      return 1;
    }
//  }
  s = sst_file_writer.Finish();
  if (!s.ok()) {
    printf("error closing file %s", s.ToString().c_str());
    return 1;
  }

  s = DB::Open(options, "./rocksdb", &db);
  assert(s.ok());

  IngestExternalFileOptions info;
  s = db -> IngestExternalFile({file_path},info);

  delete db;
  return 0;
}
