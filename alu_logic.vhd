----------------------------------------------------------------------------------
-- Company:  Chalmers university of technology, Sweden.
-- Engineer: Prathamesh Prabhakar Moralwar
-- 
-- Create Date: 11/19/2017 10:16:28 AM
-- Design Name: alu_logic.VHDL
-- Module Name: alu_logic - Behavioral
-- Project Name: 32 Bit ALU 
-- Target Devices: 65 nm ASIC
-- Tool Versions: Cadence NCSIM
-- Description: This block performs the logical operations.

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

entity alu_logic IS
	
	port(	A: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
           	B: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		LOGIC_SELECT: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
           	LOGIC_OUT: OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END alu_logic ;

ARCHITECTURE arch_alu_logic OF alu_logic  IS
BEGIN
-- based on the opcode perform all the logical operations on the input a and b.

	LOGIC_OUT <= (A AND B) WHEN LOGIC_SELECT = "00" ELSE
		     (A OR B) WHEN LOGIC_SELECT = "01" ELSE
		     (A XOR B) WHEN LOGIC_SELECT = "10" ELSE
		     (A NOR B) WHEN LOGIC_SELECT = "11";
END arch_alu_logic;
