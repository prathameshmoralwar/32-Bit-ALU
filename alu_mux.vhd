----------------------------------------------------------------------------------
-- Company:  Chalmers university of technology, Sweden.
-- Engineer: Prathamesh Prabhakar Moralwar
-- 
-- Create Date: 11/19/2017 10:16:28 AM
-- Design Name: alu_mux.VHDL
-- Module Name: alu_mux - Behavioral
-- Project Name: 32 Bit ALU 
-- Target Devices: 65 nm ASIC
-- Tool Versions: Cadence NCSIM
-- Description: ALU_Mux module selects the different blocks output based on the opcodes.
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

entity alu_mux is
		PORT(	SUM: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
           	LOGIC: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		SHIFT: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		COMP: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		SEL: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
           	MUX_OUTPUT: OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
end alu_mux;

ARCHITECTURE arch_alu_mux OF alu_mux  is
BEGIN

--all the inputs should be in the process for combinational logic to be inferred rightly.

process (sel,sum,logic,shift,comp)
begin
			
		case SEL is
		  when "00" => MUX_OUTPUT <= SUM;
		  when "01" => MUX_OUTPUT <= LOGIC;
		  when "10" => MUX_OUTPUT <= SHIFT;
		  --11 condition could actually be added without any effect.
		  -- adding back 11 condtion based on the invalid opcode results. 
		  when "11" => MUX_OUTPUT <= COMP;
		  --when others => MUX_OUTPUT <= SUM;
		  when others => MUX_OUTPUT <= (others => '0');
		  
	    end case; 					  
	end process;
end arch_alu_mux;
