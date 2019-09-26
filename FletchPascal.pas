{$mode objfpc}
{$m+}
program FletchPascal;
uses crt;
type
    FletchPascal = class 
    private


    public
        function Fletcher16(Stream: TStream): word
        function Fletcher32(Stream: TStream): longword
        function Fletcher64(Stream: TStream): qword
    end;
var 
    function FletchPascal.Fletcher16(Stream: TStream): word
    begin
        a,b: byte;
        Buffer: array[0.. Stream.Length()-1] of byte;
        Stream.ReadBuffer(Buffer, Stream.Length());
        for _b in Buffer do
            begin
                a:= (a + _b) % 0xff
                b:= (b + a) % 0xff
            end;  
        Fletcher16:= (b << 8)  
    end;
    function FletchPascal.Fletcher32(Stream: TStream): longword
    begin
        a,b: word;
        Buffer: array[0.. Stream.Length()-1] of byte;
        Stream.ReadBuffer(Buffer, Stream.Length());
        for _b in Buffer do
            begin
                a:= (a + _b) % 0xffff 
                b:= (b + a) % 0xffff
            end;    
    end;
function FletchPascal.Fletcher64(Stream: TStream): qword
    begin
        a,b: longword;
        Buffer: array[0.. Stream.Length()-1] of byte;
        Stream.ReadBuffer(Buffer, Stream.Length());
        for _b in Buffer do
            begin
                a:= (a + _b) % 0xffffff 
                b:= (b + a) % 0xffffff
            end;    
    end;
begin
    
    
end.