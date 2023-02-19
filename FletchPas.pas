unit FletchPas;

{$mode ObjFPC}{$H+}

interface

type
    HashPas = class



  private
  function ArrayToTBytes(const bytes: array of Byte): array of Byte;
  function RotateLeft(b: byte; n: integer): byte;
function RotateRight(b: byte; n: integer): byte;
 function splitChunkIntoWords(chunk: array of Byte, startIndex: QWord): array of Byte;
 public
function LRC(B: array of Byte): Byte;
function CRC8(B: array of Byte): Byte;
function Fletcher16(B: array of Byte): Word;
function Fletcher32(B: array of Byte): LongWord;
function Fletcher64(B: array of Byte): QWord;
function SHA2(B: array of Byte): Word;

        end;

implementation
function HashPas.CRC8(B: array of Byte): Byte;
const
  Polynomial = $07;
var
  I, J: QWord;
  CRC: Byte;
begin

  CRC := $00;
  for I := 0 to High(B) do
  begin
    CRC := CRC xor B[I];
    for J := 0 to 7 do
    begin
      if (CRC and $80) <> 0 then
      begin
        CRC := (CRC shl 1) xor Polynomial;
      end
      else
      begin
        CRC := CRC shl 1;
      end;

    end;
  end;
  Result := CRC xor $55;
end;
function HashPas.LRC(B: array of Byte): Byte;
var
  i: QWord;
  parity: Byte;
begin
  parity := 0;
  for i := 0 to High(B) do
  begin
    parity := parity xor B[i];
  end;
  Result := parity;
end;
function HashPas.Fletcher16(B: array of Byte): Word;
var
  sum1, sum2: Byte;
  i: QWord;
begin
  sum1 := 0;
  sum2 := 0;
  for i := 0 to High(B) do
  begin
    sum1 += B[i] mod 255;
    sum2 += sum1 mod 255;
  end;

  Result := (Word(sum1) shl 8) or sum2;
end;
function HashPas.Fletcher32(B: array of Byte): LongWord;
var
  sum1, sum2: Word;
  i: QWord;
begin
  sum1 := 0;
  sum2 := 0;
  for i := 0 to High(B) do
  begin
    sum1 += B[i] mod 65535;
    sum2 += sum1 mod 65535;
  end;

  Result := (LongWord(sum1) shl 16) or sum2;
end;
function HashPas.Fletcher64(B: array of Byte): QWord;
var
  sum1, sum2: LongWord;
  i: QWord;
begin
  sum1 := 0;
  sum2 := 0;
  for i := 0 to High(B) do
  begin
    sum1 += B[i] mod 4294967295;
    sum2 += sum1 mod 4294967295;
  end;

  Result := (QWord(sum1) shl 32) or sum2;
end;
function HashPas.ArrayToTBytes(const bytes: array of Byte): array of Byte;
begin
  SetLength(Result, Length(bytes));
  Move(bytes[0], Result[0], Length(bytes));
end;
function HashPas.QWordToBigEndianBytes(value: QWord): array of Byte;
var
  I : Byte;
begin
  SetLength(Result, 8);
  for I = 0 to 7 do
  begin
  Result[I] := Byte((value shr i*8) and $FF);
  end;
  end;
end;
  function HashPas.splitChunkIntoWords(chunk: array of Byte, startIndex: QWord): array of Byte;
var
  I : Byte;
  startByteIndex: Word;
begin
     SetLength(Result, 16);
      for I = 0 to 15 do
      begin
          startByteIndex := startIndex + (I * 4);
          Result[I] := (chunk[startByteIndex] << 24) |
                      (chunk[startByteIndex + 1] << 16) |
                      (chunk[startByteIndex + 2] << 8) |
                      chunk[startByteIndex + 3]);
      end;
end;
function HashPas.SHA2(B: array of Byte): QWord;
const
  // padding
  const NUMBLOCKS = paddedMsg.length / 64;
  const MSG_LEN = QWordToBigEndianBytes(High(B) * 8); // message length in bits
  const P = 512 - ((msgLen + 64) mod 512); // number of padding bits required
    // append 1 bit
  // constants
  H0 = 0x6a09e667;
  H1 = 0xbb67ae85;
  H2 = 0x3c6ef372;
  H3 = 0xa54ff53a;
  H4 = 0x510e527f;
  H5 = 0x9b05688c;
  H6 = 0x1f83d9ab;
  H7 = 0x5be0cd19;
  K = [
   0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
   0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
   0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
   0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
   0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
   0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
   0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
   0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2];
var
  blockBuffer: array of Byte;
  blocks: array of array of LongWord;
  message: array of Byte = B;
  sum1, sum2: LongWord;

  I,J,numBlocks: QWord;
begin
  // step 1: paddings
  Insert(array of byte($80),message);
  SetLength(message, Length(message) + P div 8); //append zero bits
  Insert(MSG_LEN, message, Length(message)); //append message length

  // step2: parsing
  numBlocks := Length(message) div 64; //how many blocks of
  SetLength(blocks, 64, 16);  //each block has 16 32-bit integers
  for I = 0 to Length(message) step 64 do
  begin
        blocks[I] := splitChunkIntoWords(array, I * 64);
  end;
  for 0 o 63 do
  begin
       blocks
  end;
  for


  Result := (QWord(sum1) shl 32) or sum2;
end;
function HashPas.Hunter8(B: array of Byte): Word;
const
     poly = $D5;
var
  h0: Word = $;
  h1
  h2
  h3: Byte;
  var2: Byte;
  var3: Byte;
  i,j: QWord;
begin
  var2 := $31;
  var1 := $D5;
  for i := 0 to High(B) do
  begin
    var3 := var1;
    var1 := RotateRight(var1,B[i]);
    var2 := var1 and RotateLeft(var2,B[i]);
    var1:= var3 and var1;
    var3 := var2;
    for j := 0 to 7 do
  begin
        var3 := var3 and (poly shr j);
  end;
    for j := 0 to 7 do
  begin
        var2 := (var2 + RotateLeft(var1,var2)) mod $FF;
  end;


end;
  Result := (var2 + var3) mod $FF;
  end;
   function HashPas.RotateLeft(b: byte; n: integer): byte;
begin
  RotateLeft := (b shl n) or (b shr (8 - n));
end;
   function HashPas.RotateRight(b: byte; n: integer): byte;
begin
  RotateRight := (b shr n) or (b shl (8 - n));
end;
end.
