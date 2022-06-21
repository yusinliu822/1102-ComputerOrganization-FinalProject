# 1102-ComputerOrganization-FinalProject

## Questions

### Q0. GEM5 + NVMAIN BUILD-UP (40%)
照著PPT做就對了
:::warning
不要在windows 解壓縮 .tar.gz
:::

### Q1. Enable L3 last level cache in GEM5 + NVMAIN (15%)
1. modify
    - `gem5/configs/common/Caches.py`
    - `gem5/configs/common/Options.py`
    - `gem5/src/cpu/BaseCPU.py`
    - `gem5/src/mem/XBar.py`
    - `gem5/configs/common/CacheConfig.py`
<!-- ![](https://i.imgur.com/Znt0Vpq.png =300x) -->
2. recompile
```
scons EXTRAS=../NVmain build/X86/gem5.opt
```
3. run hello world
```
./build/X86/gem5.opt configs/example/se.py \
-c tests/test-progs/hello/bin/x86/linux/hello \
--cpu-type=TimingSimpleCPU --caches --l2cache --l3cache --mem-type=NVMainMemory \
--nvmain-config=../NVmain/Config/PCM_ISSCC_2012_4GB.config
```
- [ref]
    - https://blog.csdn.net/tristan_tian/article/details/79851063
    - https://groups.google.com/g/gem5-gpu-dev/c/N-EJAu885t8

### Q2. Config last level cache to  2-way and full-way associative cache and test performance (15%)
> 必須跑benchmark quicksort在 2-way跟 full way
1. compile quicksort.c
```
gcc --static quicksort.c -o quicksort
```
2. recompile
```
scons EXTRAS=../NVmain build/X86/gem5.opt
```
3. run
```
./build/X86/gem5.opt configs/example/se.py \
-c ../benchmark/quicksort --cpu-type=TimingSimpleCPU \
--caches --l1i_size=32kB --l1d_size=32kB --l2cache --l2_size=128kB \
--l3cache --l3_size=1MB --l3_assoc=16384 --mem-type=NVMainMemory \
--nvmain-config=../NVmain/Config/PCM_ISSCC_2012_4GB.config > cmdlog_full-way.txt
```
```
./build/X86/gem5.opt configs/example/se.py \
-c ../benchmark/quicksort --cpu-type=TimingSimpleCPU \
--caches --l1i_size=32kB --l1d_size=32kB --l2cache --l2_size=128kB \
--l3cache --l3_size=1MB --l3_assoc=2 --mem-type=NVMainMemory \
--nvmain-config=../NVmain/Config/PCM_ISSCC_2012_4GB.config > cmdlog_2-way.txt
```


### Q3. Modify last level cache policy based on frequency based replacement policy (15%)
![](https://i.imgur.com/X26eMZ0.png =300x)
1. add
    - `gem5/src/mem/cache/replacement_policies/fb_rp.cc`
    - `gem5/src/mem/cache/replacement_policies/fb_rp.hh`
2. modifiy
    - `gem5/src/mem/cache/replacement_policies/ReplacementPolicies.py`
    - `gem5/src/mem/cache/replacement_policies/SConscript`
    - `gem5/configs/common/Caches.py`
3. recompile
```
scons EXTRAS=../NVmain build/X86/gem5.opt
```
4. run 
```
./build/X86/gem5.opt configs/example/se.py \
-c ../benchmark/quicksort --cpu-type=TimingSimpleCPU \
--caches --l1i_size=32kB --l1d_size=32kB --l2cache --l2_size=128kB \
--l3cache --l3_size=1MB --l3_assoc=2 --mem-type=NVMainMemory \
--nvmain-config=../NVmain/Config/PCM_ISSCC_2012_4GB.config > cmdlog_FB.txt
```
```
./build/X86/gem5.opt configs/example/se.py \
-c ../benchmark/quicksort --cpu-type=TimingSimpleCPU \
--caches --l1i_size=32kB --l1d_size=32kB --l2cache --l2_size=128kB \
--l3cache --l3_size=1MB --l3_assoc=2 --mem-type=NVMainMemory \
--nvmain-config=../NVmain/Config/PCM_ISSCC_2012_4GB.config > cmdlog_LRU.txt
```

### Q4. Test the performance of write back and write through policy based on 4-way associative cache with isscc_pcm(15%) 
> 必須跑 benchmark multiply 在 write through跟 write back

- modified `base.cc`
> 不確定改的對不對，好像是錯的

### Q5. Bonus (10%)
Design last level cache policy to reduce the energy consumption of pcm_based main memory 
Baseline:LRU
> 可以去mem/cache的資料夾下找到兩個檔案一個叫做cache.cc另一個叫做base.cc，可以研究一下gem5底層的code是如何把資料寫入Memory。

> 未完成

---

### reference

- Data Cache Management Using Frequency-Based Replacement
    - https://dl.acm.org/doi/pdf/10.1145/98457.98523
- documents
    - https://pages.cs.wisc.edu/~swilson/gem5-docs/index.html
    - https://www.gem5.org/documentation/learning_gem5/part2/helloobject/
- MSHR: Miss Status and handling Register.
    - https://pages.cs.wisc.edu/~swilson/gem5-docs/classMSHR.html
    - https://groups.google.com/g/gem5-gpu-dev/c/kDvejmAIqKQ/m/qkXcj9ZrxS4J

