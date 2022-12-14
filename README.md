# FletchPas
A unit Implementation of Fletcher's checksum in Delphi/FreePascal 
# Usage
```pascal
Checksum16: word = FletchPas.Fletcher16(ByteStream);
Checksum32: longword = FletchPas.Fletcher32(ByteStream);
Checksum64: QWord = FletchPas.Fletcher64(ByteStream);
//takes TStream
```
