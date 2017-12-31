----------------------------------------------------------------------------------
-- Company:  Chalmers university of technology, Sweden.
-- Engineer: Prathamesh Prabhakar Moralwar
-- 
-- Create Date: 11/19/2017 10:16:28 AM
-- Design Name: alu_comp.VHDL
-- Module Name: alu_comp - Behavioral
-- Project Name: 32 Bit ALU 
-- Target Devices: 65 nm ASIC
-- Tool Versions: Cadence NCSIM
-- Description: This block performs the comparision operations.
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

ENTITY alu_comp IS
	PORT(	CARRY: IN STD_LOGIC;
           	OVERFLOW: IN STD_LOGIC;
		MSB_BIT: IN STD_LOGIC;
		SEL: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
           	RESULT: OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END alu_comp ;

ARCHITECTURE arch_alu_comp OF alu_comp  IS
	SIGNAL temp_result: STD_LOGIC;
	SIGNAL zeroes: STD_LOGIC_VECTOR(30 DOWNTO 0);
BEGIN
--using the overflow and msb bit from the adder block to calculate the result.

	zeroes <= (others => '0');
	temp_result <=  (MSB_BIT XOR OVERFLOW) WHEN SEL = "10" ELSE
		   (NOT CARRY) WHEN SEL = "11" ELSE 
		  'Z';
	RESULT <= zeroes & temp_result;	     
END arch_alu_comp;
