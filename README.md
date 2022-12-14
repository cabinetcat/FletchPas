# FletchPas
A unit Implementation of Fletcher's checksum in Delphi/FreePascal 
# Usage
```pascal
uses
  sysutils,
  // include the FletchPas unit
  FletchPas;

var
  bytes: array of Byte = (13, 56, 123); 
  checksum16: Word;
  checksum32: LongWord;
  checksum64: QWord;

begin
  checksum16 := Fletcher16(bytes);
  checksum32 := Fletcher32(bytes);
  checksum64 := Fletcher64(bytes);

  WriteLn(IntToHex(checksum16));
  WriteLn(IntToHex(checksum32));
  WriteLn(IntToHex(checksum64));    
  
// Output: 
// C012
// 00C00112
// 000000C000000112
```

