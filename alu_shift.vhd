----------------------------------------------------------------------------------
-- Company:  Chalmers university of technology, Sweden.
-- Engineer: Prathamesh Prabhakar Moralwar
-- 
-- Create Date: 11/19/2017 10:16:28 AM
-- Design Name: alu_shift.VHDL
-- Module Name: alu_shift - Behavioral
-- Project Name: 32 Bit ALU 
-- Target Devices: 65 nm ASIC
-- Tool Versions: Cadence NCSIM
-- Description: This block performs the shifting opeation.

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

entity alu_shift is
	
	PORT(	A: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
           	B: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		SEL: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
           	SHIFT_RESULT: OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END alu_shift ;

ARCHITECTURE arch_alu_shift OF alu_shift  is
BEGIN
-- shift operations based on the opcode, you must convert B first for the shifting opeation.

	SHIFT_RESULT <=  STD_LOGIC_VECTOR(SHIFT_LEFT(unsigned(A), NATURAL(to_integer(unsigned(B(4 DOWNTO 0)))))) WHEN SEL = "00" ELSE
			 STD_LOGIC_VECTOR(SHIFT_RIGHT(unsigned(A), NATURAL(to_integer(unsigned(B(4 DOWNTO 0)))))) WHEN SEL = "10" ELSE
			 STD_LOGIC_VECTOR(SHIFT_RIGHT(signed(A), NATURAL(to_integer(unsigned(B(4 DOWNTO 0)))))) WHEN SEL = "11" ELSE
		     	 (others => '0');
END arch_alu_shift;
