`define     PC_INIT         32'h00400000
`define     DMEM_BASE       32'h10010000

`define     MAX_MEMORY      32'd1023
`define     ADDR_BYTES      32'd10

`define     IF_STATE        32'd0
`define     ID_STATE        32'd1
`define     EXE_STATE       32'd2
`define     MEM_STATE       32'd3
`define     WB_STATE        32'd4

`define     CODE_NUM        32'd33

`define     ADD             64'h0000_0001
`define     ADDU            64'h0000_0002
`define     SUB             64'h0000_0004
`define     SUBU            64'h0000_0008
`define     AND             64'h0000_0010
`define     OR              64'h0000_0020
`define     XOR             64'h0000_0040
`define     NOR             64'h0000_0080
`define     SLT             64'h0000_0100
`define     SLTU            64'h0000_0200
`define     SLL             64'h0000_0400
`define     SRL             64'h0000_0800
`define     SRA             64'h0000_1000
`define     SLLV            64'h0000_2000
`define     SRLV            64'h0000_4000
`define     SRAV            64'h0000_8000     
`define     JR              64'h0001_0000
`define     ADDI            64'h0002_0000
`define     ADDIU           64'h0004_0000
`define     ANDI            64'h0008_0000
`define     ORI             64'h0010_0000
`define     XORI            64'h0020_0000
`define     LW              64'h0040_0000
`define     SW              64'h0080_0000
`define     BEQ             64'h0100_0000
`define     BNE             64'h0200_0000
`define     SLTI            64'h0400_0000
`define     SLTIU           64'h0800_0000
`define     LUI             64'h1000_0000
`define     J               64'h2000_0000
`define     JAL             64'h4000_0000
`define     BRK             64'h8000_0000
`define     MUL             64'h0001_0000_0000         

`define     _ADD            0
`define     _ADDU           1
`define     _SUB            2
`define     _SUBU           3
`define     _AND            4
`define     _OR             5
`define     _XOR            6
`define     _NOR            7
`define     _SLT            8
`define     _SLTU           9
`define     _SLL            10
`define     _SRL            11
`define     _SRA            12
`define     _SLLV           13
`define     _SRLV           14
`define     _SRAV           15    
`define     _JR             16
`define     _ADDI           17
`define     _ADDIU          18
`define     _ANDI           19
`define     _ORI            20
`define     _XORI           21
`define     _LW             22
`define     _SW             23
`define     _BEQ            24
`define     _BNE            25
`define     _SLTI           26
`define     _SLTIU          27
`define     _LUI            28
`define     _J              29
`define     _JAL            30
`define     _BRK            31
`define     _MUL            32

`define     IFC             Code_type[`IF_STATE]
`define     IDC             Code_type[`ID_STATE]
`define     EXEC            Code_type[`EXE_STATE]
`define     MEMC            Code_type[`MEM_STATE]
`define     WBC             Code_type[`WB_STATE]

`define     ID_PAUSE        5'b00011
`define     NO_PAUSE        5'b00000
`define     HALT            5'b11111

`define     INT_ENTRY       32'h00400004