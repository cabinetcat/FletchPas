unit FletchPas;

{$mode ObjFPC}{$H+}

interface
         function Fletcher16(B: array of Byte): Word;
         function Fletcher32(B: array of Byte): LongWord;
         function Fletcher64(B: array of Byte): QWord;


implementation
              function Fletcher16(B: array of Byte): Word;
              var
                 sum1, sum2: Byte;
                 i: QWord;
              begin
                   sum1 := 0;
                   sum2 := 0;
                   for i := 0 to length(B)-1 do
                       begin
	               sum1 += B[i] mod 255;
                       sum2 += sum1 mod 255;
                       end;

                   Result := (Word(sum1) shl 8) or sum2;
              end;
              function Fletcher32(B: array of Byte): LongWord;
              var
                 sum1, sum2: Word;
                 i: QWord;
              begin
                   sum1 := 0;
                   sum2 := 0;
                   for i := 0 to length(B)-1 do
                       begin
	               sum1 += B[i] mod 65535;
                       sum2 += sum1 mod 65535;
                       end;

                   Result := (LongWord(sum1) shl 16) or sum2;
              end;
              function Fletcher64(B: array of Byte): QWord;
              var
                 sum1, sum2: LongWord;
                 i: QWord;
              begin
                   sum1 := 0;
                   sum2 := 0;
                   for i := 0 to length(B)-1 do
                       begin
	               sum1 += B[i] mod 4294967295;
                       sum2 += sum1 mod 4294967295;
                       end;

                   Result := (QWord(sum1) shl 32) or sum2;
              end;

end.
