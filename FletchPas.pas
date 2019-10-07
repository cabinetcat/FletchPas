unit FletchPas;
interface
uses classes;
    function Fletcher16(Stream: TStream): word;
    function Fletcher32(Stream: TStream): longword;
    function Fletcher64(Stream: TStream): qword;
implementation
    function Fletcher16(Stream: TStream; startIndex: qword = 0; endIndex: qword = nil): word;
    var
        a,b: byte;
        endReadIndex: qword;
        Buffer: array[0.. Stream.Size - 1] of byte;
    begin        
        if endIndex = nil then endReadIndex:= Stream.Size;
        Stream.Seek(startIndex,0);
        Stream.ReadBuffer(Buffer, endReadIndex);
        for _b in Buffer do
            begin
                a:= (a + _b) mod $ff;
                b:= (b + a) mod $ff;
            end;  
        Fletcher16:= (b << 8) or a;
    end;
    function Fletcher32(Stream: TStream; startIndex: qword = 0; endIndex: qword = nil): longword;
    var
        a,b: word;
        endReadIndex: qword;
        Buffer: array[0.. Stream.Size - 1] of byte;
    begin        
        if endIndex = nil then endReadIndex:= Stream.Size;
        Stream.Seek(startIndex,0);
        Stream.ReadBuffer(Buffer, endReadIndex);
        for _b in Buffer do
            begin
                a:= (a + _b) mod $ffff;
                b:= (b + a) mod $ffff;
            end;  
        Fletcher32:= (b << 16) or a;
    end;


    
    
end.