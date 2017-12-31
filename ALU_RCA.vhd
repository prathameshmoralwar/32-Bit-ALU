----------------------------------------------------------------------------------
-- Company:  Chalmers university of technology, Sweden.
-- Engineer: Prathamesh Prabhakar Moralwar
-- 
-- Create Date: 11/19/2017 10:16:28 AM
-- Design Name: ALU_RCA.VHDL
-- Module Name: ALU_RCA - Behavioral
-- Project Name: 32 Bit ALU 
-- Target Devices: 65 nm ASIC
-- Tool Versions: Cadence NCSIM
-- Description: Top level block which is just connecting all the blocks together with registered inputs and outputs.
-- 
-- Dependencies:  All the submodules
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity ALU_RCA IS
	port(	Clk    : in  std_logic;
		Reset  : in  std_logic;	
		A: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
           	B: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		Op: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
           	Outs: OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
end ALU_RCA;

architecture arch_ALU_RCA OF ALU_RCA IS

	component adder_subtractor IS
	    port(	A: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
           		B: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADD_SUB: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
           		SUM: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			OVERFLOW: OUT STD_LOGIC;
			CARRY: OUT STD_LOGIC);
	end component adder_subtractor;

	component alu_logic IS
	    port(	A: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
           		B: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			LOGIC_SELECT: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
           		LOGIC_OUT: OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
	end component alu_logic;

	component alu_shift IS
	   port(	A: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
           		B: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			SEL: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
           		SHIFT_RESULT: OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
	end component alu_shift;

	component alu_comp IS
	    port(	CARRY: IN STD_LOGIC;
           		OVERFLOW: IN STD_LOGIC;
			MSB_BIT: IN STD_LOGIC;
			SEL: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
           		RESULT: OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
	end component alu_comp;

	component alu_mux IS
	    port(	SUM: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
           		LOGIC: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			SHIFT: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			COMP: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			SEL: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
           		MUX_OUTPUT: OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
	end component alu_mux;

	SIGNAL inputA: STD_LOGIC_VECTOR(31 DOWNTO 0); 
	SIGNAL inputB: STD_LOGIC_VECTOR(31 DOWNTO 0); 
	SIGNAL opCode: STD_LOGIC_VECTOR(3 DOWNTO 0); 
	 

	SIGNAL adderSum: STD_LOGIC_VECTOR(31 DOWNTO 0); 
	SIGNAL oFlow: STD_LOGIC;
	SIGNAL carryOut: STD_LOGIC;
	SIGNAL logicOutput: STD_LOGIC_VECTOR(31 DOWNTO 0); 
	SIGNAL shiftOutput: STD_LOGIC_VECTOR(31 DOWNTO 0); 
	SIGNAL compOutput: STD_LOGIC_VECTOR(31 DOWNTO 0); 
	SIGNAL muxOutput: STD_LOGIC_VECTOR(31 DOWNTO 0); 
	SIGNAL muxOutput_reg: STD_LOGIC_VECTOR(31 DOWNTO 0); 
BEGIN
	P: PROCESS (clk)
	BEGIN
		IF(rising_edge(Clk)) THEN
			IF(Reset = '0') THEN
				inputA <= (others => '0');
				inputB <= (others => '0');
				opCode <= (others => '0');
				muxOutput_reg <= (others => '0');
			ELSE
				inputA <= A;
				inputB <= B;
				opCode <= Op;
				muxOutput_reg <= muxOutput;
			end IF;
		end IF;
	end PROCESS P;

	Adder: adder_subtractor port MAP(A => inputA, B => inputB, ADD_SUB => opCode(1 DOWNTO 0), SUM => adderSum, OVERFLOW => oFlow, CARRY => carryOut);
	LOGIC: alu_logic port MAP(A => inputA, B => inputB, LOGIC_SELECT => opCode(1 DOWNTO 0), LOGIC_OUT => logicOutput);
	SHIFT: alu_shift port MAP(A => inputA, B => inputB, SEL => opCode(1 DOWNTO 0), SHIFT_RESULT => shiftOutput);
	COMP:  alu_comp port MAP(CARRY => carryOut, OVERFLOW => oFlow, MSB_BIT => adderSum(31), SEL => opCode(1 DOWNTO 0), RESULT => compOutput);
	MUX:   alu_MUX port MAP(SUM => adderSum, LOGIC => logicOutput, SHIFT => shiftOutput, COMP => compOutput, SEL => opCode(3 DOWNTO 2), MUX_OUTPUT => muxOutput); 
	
	Outs <= muxOutput_reg ;
end arch_ALU_RCA;
