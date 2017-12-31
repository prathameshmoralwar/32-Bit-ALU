----------------------------------------------------------------------------------
-- Company:  Chalmers university of technology, Sweden.
-- Engineer: Prathamesh Prabhakar Moralwar
-- 
-- Create Date: 11/19/2017 10:16:28 AM
-- Design Name: full_adder.VHDL
-- Module Name: full_adder - Behavioral
-- Project Name: 32 Bit ALU 
-- Target Devices: 65 nm ASIC
-- Tool Versions: Cadence NCSIM
-- Description: Full adder to perform the addition and subtraction.
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

ENTITY full_adder IS
	PORT(	a: IN STD_LOGIC;
           	b: IN STD_LOGIC;
		cin: IN STD_LOGIC;
           	sum: OUT STD_LOGIC;
		cout: OUT STD_LOGIC);
END full_adder;

ARCHITECTURE arch_full_adder OF full_adder IS
BEGIN
	sum <= a XOR b XOR cin;
	cout <= (a AND b) OR (b AND cin) OR (cin AND a);
END arch_full_adder;
