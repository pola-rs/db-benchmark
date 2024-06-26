#!/usr/bin/env Rscript

cat("# groupby-arrow\n")

source("./_helpers/helpers.R")

stopifnot(requireNamespace("bit64", quietly=TRUE)) # used in chk to sum numeric columns
.libPaths("./arrow/r-arrow") # tidyverse/dplyr#4641 ## leave it like here in case if this affects arrow pkg as well
suppressPackageStartupMessages({
  library("arrow", lib.loc="./R-arrow/r-arrow", warn.conflicts=FALSE)
  library("dplyr", lib.loc="./R-arrow/r-arrow", warn.conflicts=FALSE)
})
ver = packageVersion("arrow")
git = ""
task = "groupby"
solution = "R-arrow"
fun = "group_by"
cache = TRUE
on_disk = FALSE

data_name = Sys.getenv("SRC_DATANAME")
src_grp = file.path("data", paste(data_name, "csv", sep="."))
cat(sprintf("loading dataset %s\n", data_name))

# arrow currently does not support Unifying differing dictionaries, so we import the string types as strings
x = read_csv_arrow(src_grp, schema = schema(id1=string(),id2=string(),id3=string(),id4=int32(),id5=int32(),id6=int32(),v1=int32(),v2=int32(),v3=double()), skip=1, as_data_frame=FALSE)
print(nrow(x))

task_init = proc.time()[["elapsed"]]
cat("grouping...\n")

question = "sum v1 by id1" # q1
t = system.time({
    ans <- collect(x %>% group_by(id1) %>% summarise(v1=sum(v1, na.rm=TRUE)))
    print(dim(ans))
})[["elapsed"]]
m = memory_usage()
chk <- summarise(ungroup(ans), v1=sum(bit64::as.integer64(v1)))
chkt = system.time(chk <- collect(chk))[["elapsed"]]
write.log(run=1L, task=task, data=data_name, in_rows=nrow(x), question=question, out_rows=nrow(ans), out_cols=ncol(ans), solution=solution, version=ver, git=git, fun=fun, time_sec=t, mem_gb=m, cache=cache, chk=make_chk(chk), chk_time_sec=chkt, on_disk=on_disk)
rm(ans)
t = system.time({
    ans <- collect(x %>% group_by(id1) %>% summarise(v1=sum(v1, na.rm=TRUE)))
    print(dim(ans))
})[["elapsed"]]
m = memory_usage()
chkt = system.time(chk <- collect(summarise(ungroup(ans), v1=sum(bit64::as.integer64(v1)))))[["elapsed"]]
write.log(run=2L, task=task, data=data_name, in_rows=nrow(x), question=question, out_rows=nrow(ans), out_cols=ncol(ans), solution=solution, version=ver, git=git, fun=fun, time_sec=t, mem_gb=m, cache=cache, chk=make_chk(chk), chk_time_sec=chkt, on_disk=on_disk)
ans <- collect(ans)
print(head(ans, 3))
print(tail(ans, 3))
rm(ans)

question = "sum v1 by id1:id2" # q2
t = system.time({
  ans<-collect(x %>% group_by(id1, id2) %>% summarise(v1=sum(v1, na.rm=TRUE)))
  print(dim(ans))
})[["elapsed"]]
m = memory_usage()
chkt = system.time(chk <- collect(summarise(ungroup(ans), v1=sum(bit64::as.integer64(v1)))))[["elapsed"]]
write.log(run=1L, task=task, data=data_name, in_rows=nrow(x), question=question, out_rows=nrow(ans), out_cols=ncol(ans), solution=solution, version=ver, git=git, fun=fun, time_sec=t, mem_gb=m, cache=cache, chk=make_chk(chk), chk_time_sec=chkt, on_disk=on_disk)
rm(ans)
t = system.time({
  ans<-collect(x %>% group_by(id1, id2) %>% summarise(v1=sum(v1, na.rm=TRUE)))
  print(dim(ans))
})[["elapsed"]]
m = memory_usage()
chkt = system.time(chk <- collect(summarise(ungroup(ans), v1=sum(bit64::as.integer64(v1)))))[["elapsed"]]
write.log(run=2L, task=task, data=data_name, in_rows=nrow(x), question=question, out_rows=nrow(ans), out_cols=ncol(ans), solution=solution, version=ver, git=git, fun=fun, time_sec=t, mem_gb=m, cache=cache, chk=make_chk(chk), chk_time_sec=chkt, on_disk=on_disk)
ans <- collect(ans)
print(head(ans, 3))
print(tail(ans, 3))
rm(ans)

question = "sum v1 mean v3 by id3" # q3
t = system.time({
  ans<- collect(x %>% group_by(id3) %>% summarise(v1=sum(v1, na.rm=TRUE), v3=mean(v3, na.rm=TRUE)))
  print(dim(ans))
})[["elapsed"]]
m = memory_usage()
chkt = system.time(chk <- collect(summarise(ungroup(ans), v1=sum(bit64::as.integer64(v1)), v3=sum(v3))))[["elapsed"]]
write.log(run=1L, task=task, data=data_name, in_rows=nrow(x), question=question, out_rows=nrow(ans), out_cols=ncol(ans), solution=solution, version=ver, git=git, fun=fun, time_sec=t, mem_gb=m, cache=cache, chk=make_chk(chk), chk_time_sec=chkt, on_disk=on_disk)
rm(ans)
t = system.time({
  ans<- collect(x %>% group_by(id3) %>% summarise(v1=sum(v1, na.rm=TRUE), v3=mean(v3, na.rm=TRUE)))
  print(dim(ans))
})[["elapsed"]]
m = memory_usage()
chkt = system.time(chk <- collect(summarise(ungroup(ans), v1=sum(bit64::as.integer64(v1)), v3=sum(v3))))[["elapsed"]]
write.log(run=2L, task=task, data=data_name, in_rows=nrow(x), question=question, out_rows=nrow(ans), out_cols=ncol(ans), solution=solution, version=ver, git=git, fun=fun, time_sec=t, mem_gb=m, cache=cache, chk=make_chk(chk), chk_time_sec=chkt, on_disk=on_disk)
ans <- collect(ans)
print(head(ans, 3))
print(tail(ans, 3))
rm(ans)

question = "mean v1:v3 by id4" # q4
t = system.time({
  ans<- collect(x %>% group_by(id4) %>% summarise(v1=mean(v1, na.rm=TRUE), v2=mean(v2, na.rm=TRUE), v3=mean(v3, na.rm=TRUE)))
  print(dim(ans))
})[["elapsed"]]
m = memory_usage()
chkt = system.time(chk <- collect(summarise(ungroup(ans), v1=sum(v1), v2=sum(v2), v3=sum(v3))))[["elapsed"]]
write.log(run=1L, task=task, data=data_name, in_rows=nrow(x), question=question, out_rows=nrow(ans), out_cols=ncol(ans), solution=solution, version=ver, git=git, fun=fun, time_sec=t, mem_gb=m, cache=cache, chk=make_chk(chk), chk_time_sec=chkt, on_disk=on_disk)
rm(ans)
t = system.time({
  ans<- collect(x %>% group_by(id4) %>% summarise(v1=mean(v1, na.rm=TRUE), v2=mean(v2, na.rm=TRUE), v3=mean(v3, na.rm=TRUE)))
  print(dim(ans))
})[["elapsed"]]
m = memory_usage()
chkt = system.time(chk <- collect(summarise(ungroup(ans), v1=sum(v1), v2=sum(v2), v3=sum(v3))))[["elapsed"]]
write.log(run=2L, task=task, data=data_name, in_rows=nrow(x), question=question, out_rows=nrow(ans), out_cols=ncol(ans), solution=solution, version=ver, git=git, fun=fun, time_sec=t, mem_gb=m, cache=cache, chk=make_chk(chk), chk_time_sec=chkt, on_disk=on_disk)
ans <- collect(ans)
print(head(ans, 3))
print(tail(ans, 3))
rm(ans)

question = "sum v1:v3 by id6" # q5
t = system.time({
  ans<-collect(x %>% group_by(id6) %>% summarise(v1=sum(v1, na.rm=TRUE), v2=sum(v2, na.rm=TRUE), v3=sum(v3, na.rm=TRUE)))
  print(dim(ans))
})[["elapsed"]]
m = memory_usage()
chkt = system.time(chk <- collect(summarise(ungroup(ans), v1=sum(bit64::as.integer64(v1)), v2=sum(bit64::as.integer64(v2)), v3=sum(v3))))[["elapsed"]]
write.log(run=1L, task=task, data=data_name, in_rows=nrow(x), question=question, out_rows=nrow(ans), out_cols=ncol(ans), solution=solution, version=ver, git=git, fun=fun, time_sec=t, mem_gb=m, cache=cache, chk=make_chk(chk), chk_time_sec=chkt, on_disk=on_disk)
rm(ans)
t = system.time({
  ans<-collect(x %>% group_by(id6) %>% summarise(v1=sum(v1, na.rm=TRUE), v2=sum(v2, na.rm=TRUE), v3=sum(v3, na.rm=TRUE)))
  print(dim(ans))
})[["elapsed"]]
m = memory_usage()
chkt = system.time(chk <- collect(summarise(ungroup(ans), v1=sum(bit64::as.integer64(v1)), v2=sum(bit64::as.integer64(v2)), v3=sum(v3))))[["elapsed"]]
write.log(run=2L, task=task, data=data_name, in_rows=nrow(x), question=question, out_rows=nrow(ans), out_cols=ncol(ans), solution=solution, version=ver, git=git, fun=fun, time_sec=t, mem_gb=m, cache=cache, chk=make_chk(chk), chk_time_sec=chkt, on_disk=on_disk)
ans <- collect(ans)
print(head(ans, 3))
print(tail(ans, 3))
rm(ans)

question = "median v3 sd v3 by id4 id5" # q6
t = system.time({
  ans<- collect(x %>% group_by(id4, id5) %>% summarise(median_v3=median(v3, na.rm=TRUE), sd_v3=sd(v3, na.rm=TRUE)))
  print(dim(ans))
})[["elapsed"]]
m = memory_usage()
chkt = system.time(chk <- collect(summarise(ungroup(ans), median_v3=sum(median_v3), sd_v3=sum(sd_v3))))[["elapsed"]]
write.log(run=1L, task=task, data=data_name, in_rows=nrow(x), question=question, out_rows=nrow(ans), out_cols=ncol(ans), solution=solution, version=ver, git=git, fun=fun, time_sec=t, mem_gb=m, cache=cache, chk=make_chk(chk), chk_time_sec=chkt, on_disk=on_disk)
rm(ans)
t = system.time({
  ans<- collect(x %>% group_by(id4, id5) %>% summarise(median_v3=median(v3, na.rm=TRUE), sd_v3=sd(v3, na.rm=TRUE)))
  print(dim(ans))
})[["elapsed"]]
m = memory_usage()
chkt = system.time(chk <- collect(summarise(ungroup(ans), median_v3=sum(median_v3), sd_v3=sum(sd_v3))))[["elapsed"]]
write.log(run=2L, task=task, data=data_name, in_rows=nrow(x), question=question, out_rows=nrow(ans), out_cols=ncol(ans), solution=solution, version=ver, git=git, fun=fun, time_sec=t, mem_gb=m, cache=cache, chk=make_chk(chk), chk_time_sec=chkt, on_disk=on_disk)
ans <- collect(ans)
print(head(ans, 3))
print(tail(ans, 3))
rm(ans)

question = "max v1 - min v2 by id3" # q7
t = system.time({
  ans<- collect(x %>% group_by(id3) %>% summarise(range_v1_v2=max(v1, na.rm=TRUE)-min(v2, na.rm=TRUE)))
  print(dim(ans))
})[["elapsed"]]
m = memory_usage()
chkt = system.time(chk <- collect(summarise(ungroup(ans), range_v1_v2=sum(bit64::as.integer64(range_v1_v2)))))[["elapsed"]]
write.log(run=1L, task=task, data=data_name, in_rows=nrow(x), question=question, out_rows=nrow(ans), out_cols=ncol(ans), solution=solution, version=ver, git=git, fun=fun, time_sec=t, mem_gb=m, cache=cache, chk=make_chk(chk), chk_time_sec=chkt, on_disk=on_disk)
rm(ans)
t = system.time({
  ans<- collect(x %>% group_by(id3) %>% summarise(range_v1_v2=max(v1, na.rm=TRUE)-min(v2, na.rm=TRUE)))
  print(dim(ans))
})[["elapsed"]]
m = memory_usage()
chkt = system.time(chk <- collect(summarise(ungroup(ans), range_v1_v2=sum(bit64::as.integer64(range_v1_v2)))))[["elapsed"]]
write.log(run=2L, task=task, data=data_name, in_rows=nrow(x), question=question, out_rows=nrow(ans), out_cols=ncol(ans), solution=solution, version=ver, git=git, fun=fun, time_sec=t, mem_gb=m, cache=cache, chk=make_chk(chk), chk_time_sec=chkt, on_disk=on_disk)
ans <- collect(ans)
print(head(ans, 3))
print(tail(ans, 3))
rm(ans)

# question = "largest two v3 by id6" # q8
# t = system.time({
#   ans<- collect(x %>% select(id6, largest2_v3=v3) %>% filter(!is.na(largest2_v3)) %>% arrange(desc(largest2_v3)) %>% group_by(id6) %>% filter(row_number() <= 2L))
#   print(dim(ans))
# })[["elapsed"]]
# m = memory_usage()
# chkt = system.time(chk <- collect(summarise(ungroup(ans), largest2_v3=sum(largest2_v3))))[["elapsed"]]
# write.log(run=1L, task=task, data=data_name, in_rows=nrow(x), question=question, out_rows=nrow(ans), out_cols=ncol(ans), solution=solution, version=ver, git=git, fun=fun, time_sec=t, mem_gb=m, cache=cache, chk=make_chk(chk), chk_time_sec=chkt, on_disk=on_disk)
# rm(ans)
# t = system.time({
#   ans<- collect(x %>% select(id6, largest2_v3=v3) %>% filter(!is.na(largest2_v3)) %>% arrange(desc(largest2_v3)) %>% group_by(id6) %>% filter(row_number() <= 2L))
#   print(dim(ans))
# })[["elapsed"]]
# m = memory_usage()
# chkt = system.time(chk <- collect(summarise(ungroup(ans), largest2_v3=sum(largest2_v3))))[["elapsed"]]
# write.log(run=2L, task=task, data=data_name, in_rows=nrow(x), question=question, out_rows=nrow(ans), out_cols=ncol(ans), solution=solution, version=ver, git=git, fun=fun, time_sec=t, mem_gb=m, cache=cache, chk=make_chk(chk), chk_time_sec=chkt, on_disk=on_disk)
# ans <- collect(ans)
# print(head(ans, 3))
# print(tail(ans, 3))
# rm(ans)

# question = "regression v1 v2 by id2 id4" # q9
# t = system.time({
#   ans <- collect(x %>% group_by(id2, id4) %>% summarise(r2=cor(v1, v2, use="na.or.complete")^2))
#   print(dim(ans))
# })[["elapsed"]]
# m = memory_usage()
# chkt = system.time(chk <- collect(summarise(ungroup(ans), r2=sum(r2))))[["elapsed"]]
# write.log(run=1L, task=task, data=data_name, in_rows=nrow(x), question=question, out_rows=nrow(ans), out_cols=ncol(ans), solution=solution, version=ver, git=git, fun=fun, time_sec=t, mem_gb=m, cache=cache, chk=make_chk(chk), chk_time_sec=chkt, on_disk=on_disk)
# rm(ans)
# t = system.time({
#   ans <- collect(x %>% group_by(id2, id4) %>% summarise(r2=cor(v1, v2, use="na.or.complete")^2))
#   print(dim(ans))
# })[["elapsed"]]
# m = memory_usage()
# chkt = system.time(chk <- collect(summarise(ungroup(ans), r2=sum(r2))))[["elapsed"]]
# write.log(run=2L, task=task, data=data_name, in_rows=nrow(x), question=question, out_rows=nrow(ans), out_cols=ncol(ans), solution=solution, version=ver, git=git, fun=fun, time_sec=t, mem_gb=m, cache=cache, chk=make_chk(chk), chk_time_sec=chkt, on_disk=on_disk)
# ans <- collect(ans)
# print(head(ans, 3))
# print(tail(ans, 3))
# rm(ans)

# question = "sum v3 count by id1:id6" # q10
# t = system.time({
#   ans <- collect(x %>% group_by(id1, id2, id3, id4, id5, id6) %>% summarise(v3=sum(v3, na.rm=TRUE), count=n()))
#   print(dim(ans))
# })[["elapsed"]]
# m = memory_usage()
# chkt = system.time(chk <- collect(summarise(ungroup(ans), v3=sum(v3), count=sum(bit64::as.integer64(count)))))[["elapsed"]]
# write.log(run=1L, task=task, data=data_name, in_rows=nrow(x), question=question, out_rows=nrow(ans), out_cols=ncol(ans), solution=solution, version=ver, git=git, fun=fun, time_sec=t, mem_gb=m, cache=cache, chk=make_chk(chk), chk_time_sec=chkt, on_disk=on_disk)
# rm(ans)
# t = system.time({
#   ans <- collect(x %>% group_by(id1, id2, id3, id4, id5, id6) %>% summarise(v3=sum(v3, na.rm=TRUE), count=n()))
#   print(dim(ans))
# })[["elapsed"]]
# m = memory_usage()
# chkt = system.time(chk <- collect(summarise(ungroup(ans), v3=sum(v3), count=sum(bit64::as.integer64(count)))))[["elapsed"]]
# write.log(run=2L, task=task, data=data_name, in_rows=nrow(x), question=question, out_rows=nrow(ans), out_cols=ncol(ans), solution=solution, version=ver, git=git, fun=fun, time_sec=t, mem_gb=m, cache=cache, chk=make_chk(chk), chk_time_sec=chkt, on_disk=on_disk)
# ans <- collect(ans)
# print(head(ans, 3))
# print(tail(ans, 3))
# rm(ans)

cat(sprintf("grouping finished, took %.0fs\n", proc.time()[["elapsed"]]-task_init))

if( !interactive() ) q("no", status=0)
