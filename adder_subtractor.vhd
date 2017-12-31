----------------------------------------------------------------------------------
-- Company:  Chalmers university of technology, Sweden.
-- Engineer: Prathamesh Prabhakar Moralwar
-- 
-- Create Date: 11/19/2017 10:16:28 AM
-- Design Name: adder_subtractor.VHDL
-- Module Name: adder_subtractor - Behavioral
-- Project Name: 32 Bit ALU 
-- Target Devices: 65 nm ASIC
-- Tool Versions: Cadence NCSIM
-- Description: This block performs the addition and subtraction operations.
-- Dependencies:  None
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity adder_subtractor IS
	
	port(	A: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
           	B: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		ADD_SUB: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
           	SUM: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		OVERFLOW: OUT STD_LOGIC;
		CARRY: OUT STD_LOGIC);
end adder_subtractor;

ARCHITECTURE arch_adder_subtractor OF adder_subtractor IS

--full adder to be used for the addition and subtraction.

	component full_adder IS
	    port(	a: IN STD_LOGIC;
           		b: IN STD_LOGIC;
			cin: IN STD_LOGIC;
           		sum: OUT STD_LOGIC;
			cout: OUT STD_LOGIC);
	end component full_adder;

	SIGNAL carry_in: STD_LOGIC_VECTOR(32 DOWNTO 0); 
	SIGNAL input_B: STD_LOGIC_VECTOR(31 DOWNTO 0); 
BEGIN
--
	carry_in(0) <= ADD_SUB(1);
	input_B <= (NOT B) WHEN ADD_SUB(1) = '1' ELSE
		    B; 
	
--generate loop to generate 32 instances of full adder to perform the addition on 32 bit.

	G: FOR i IN 0 TO 31 GENERATE
		FA: full_adder port MAP(a => A(i), b => input_B(i), cin => carry_in(i), sum => SUM(i), cout => carry_in(i+1));
	end GENERATE G;
	
-- overflow is just an xor of last two msb's carry and carry out is the carry of MSB.
-- width can be kept as it is since I still have generic declariton

	OVERFLOW <= carry_in(32) XOR carry_in(31);
	CARRY <= carry_in(32);
end arch_adder_subtractor;
