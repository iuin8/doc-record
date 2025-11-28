# Arthas Usage Record

## Hot Deploy

[参考文章](https://arthas.aliyun.com/doc/retransform.html#%E7%BB%93%E5%90%88-jad-mc-%E5%91%BD%E4%BB%A4%E4%BD%BF%E7%94%A8)

```bash
# Decompile class to
jad --source-only com.mall.domain.enums.ShowFrequencyTypeEnum > /temp/SowFrequencyTypeEnum.java
# View corresponding class loader
Sc -d com. all.domain.enums. HowFrequencyTypeEnum | grep classLoaderHash
# Compile classes (use -d specify directory [ -d /tmp])
mc -c 344561e0 /temp/SowFrequencyTypeEnum. ava
# Load class (copy the class fullpath loading class printed in the console) (PS: load content will be restored if jad is used)
redefine /com/mall/domain/enums/ShowFrequencyTypeEnum. Lass xx.class
# or use reshaping class (PS: this command can see load load with jad)
reform/com/mall/domain/enums/ShowFrequencyTypeEnum.lass xxx. Lass

# PS: Cannot upload files directly, can be uploaded using base64 encoding and then load
base64 < Test. lass > result.txt
base64-d < result.txt > Test.class
```
