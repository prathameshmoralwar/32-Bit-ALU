----------------------------------------------------------------------------------
-- Company:  Chalmers university of technology, Sweden.
-- Engineer: Prathamesh Prabhakar Moralwar
-- 
-- Create Date: 11/19/2017 10:16:28 AM
-- Design Name: ALU_TB.VHDL
-- Module Name: ALU_TB - Behavioral
-- Project Name: 32 Bit ALU 
-- Target Devices: 65 nm ASIC
-- Tool Versions: Cadence NCSIM
-- Description: This block performs the testing of 32 bit ALU.

-- Dependencies:  None
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

LIBRARY ieee;
library std;
LIBRARY WORK;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
-- Package used for reading and writing to the text file.

use std.textio.all;

ENTITY ALU_TB IS
 GENERIC(WIDTH: INTEGER := 32);
END ALU_TB;

ARCHITECTURE BEHAVIORAL OF ALU_TB IS

  COMPONENT ALU_RCA IS
     GENERIC(WIDTH: INTEGER := 32);
	 -- changing width to hardcoded value.
	 
	PORT(	Clk    : in  std_logic;
		Reset  : in  std_logic;	
		A: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
           	B: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		Op: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
           	Outs: OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
   END COMPONENT ALU_RCA;

   -- Array declared for oprand and opcode to read 1000 test vectors from the testbench.
 constant Size    : integer := 1000;
  type Operand_array is array (Size downto 0) of std_logic_vector(31 downto 0);
  type OpCode_array is array (Size downto 0) of std_logic_vector(3 downto 0);

  -- functions have been added to this file directly instead of making the package to make things simple and easy to compile in a single shot.
  

function bin (
    myChar : character)
    return std_logic is
    variable bin : std_logic;
  begin
    case myChar is
      when '0' => bin := '0';
      when '1' => bin := '1';
      when 'x' => bin := '0';
      when others => assert (false) report "no binary character read" severity failure;
    end case;
    return bin;
  end bin;

  function loadOperand (
    fileName : string)
    return Operand_array is
    file objectFile : text open read_mode is fileName;
    variable memory : Operand_array;
    variable L      : line;
    variable index  : natural := 0;
    variable myChar : character;
  begin
    while not endfile(objectFile) loop
      readline(objectFile, L);
      for i in 31 downto 0 loop
        read(L, myChar);
        memory(index)(i) := bin(myChar);
      end loop;
      index := index + 1;
    end loop;
    return memory;
  end loadOperand;


  function loadOpCode (
    fileName : string)
    return OpCode_array is
    file objectFile : text open read_mode is fileName;
    variable memory : OpCode_array;
    variable L      : line;
    variable index  : natural := 0;
    variable myChar : character;
  begin
    while not endfile(objectFile) loop
      readline(objectFile, L);
      for i in 3 downto 0 loop
        read(L, myChar);
        memory(index)(i) := bin(myChar);
      end loop;
      index := index + 1;
    end loop;
    return memory;
  end loadOpCode;

  -- End of functions and signal declartions.

   SIGNAL clk_tb_signal: STD_LOGIC := '1';
   SIGNAL reset_n_tb_signal: STD_LOGIC;
   SIGNAL counter: INTEGER RANGE 0 TO 999 := 0; 
   SIGNAL a_tb_signal:STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
   SIGNAL b_tb_signal:STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
   SIGNAL opcode_tb_signal:STD_LOGIC_VECTOR(3 DOWNTO 0);
   SIGNAL outs_tb_signal:STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);

   SIGNAL AMem       : Operand_array := (others => (others => '0'));
   SIGNAL BMem       : Operand_array := (others => (others => '0'));
   SIGNAL OpMem      : OpCode_array := (others => (others => '0'));
   SIGNAL OutputMem  : Operand_array := (others => (others => '0'));
BEGIN

-- reading from the random test vectors provided on pingpong. *.tv file has to be present along with other source file with read/write access given.

	AMem <= loadOperand(string'("A.tv"));
	BMem <= loadOperand(string'("B.tv"));
	OpMem <= loadOpCode(string'("Op.tv"));
	OutputMem <= loadOperand(string'("Output.tv"));

	-- Instatntation of the main component.

   ALU_RC_ADDER:
   COMPONENT ALU_RCA
	PORT MAP( Clk => clk_tb_signal,
		Reset => reset_n_tb_signal,	
		A => a_tb_signal,
           	B => b_tb_signal,
		Op => opcode_tb_signal,
           	Outs => outs_tb_signal);
-- reset is active low.

   reset_n_tb_signal<='0',
                '1' AFTER 400 ns;

				-- generation of clock
  
   clk_proc:
   PROCESS
   BEGIN
      WAIT FOR 50 ns;
      clk_tb_signal <= NOT(clk_tb_signal);
   END PROCESS clk_proc;

   -- Main process to read one by one test vector based on the counter value and assigning it to the signals.
   P: PROCESS
   BEGIN
        wait until rising_edge(clk_tb_signal);
		IF(reset_n_tb_signal = '0') THEN
			counter <= 0;
		ELSE
			a_tb_signal <= AMem(counter);
			b_tb_signal <= BMem(counter);
			opcode_tb_signal <= OpMem(counter);
			IF(counter > 3) THEN
--using the counter value 3 as valid output is produced only after 3 cycles..
				--WAIT FOR 150 ns; 
				-- if output signal is not equal to the reference vector provided then there is an error in the ALU.
				
      				ASSERT (outs_tb_signal = OutputMem(counter - 3))
					
					-- Reporting the error with opcode information. 
      				REPORT "Error!!! opcode = " & integer'image(to_integer(unsigned(OutputMem(counter - 3))))
      				SEVERITY ERROR;
			END IF;
			counter <= counter + 1;
			
	-- reset the counter after 1000 meaning we have compeleted the 1000 vectors reading.
	
			IF(counter = 999) THEN
				counter <= 0;
			END IF;
		END IF;
    END PROCESS P;
END;
