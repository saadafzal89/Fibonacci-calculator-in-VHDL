library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_2x1 is
	generic
	(	width	:positive	:=8);
	port
	(
		input1	:in std_logic_vector(width-1 downto 0);
		input2	:in std_logic_vector(width-1 downto 0);
		sel		:in std_logic;
		output	:out std_logic_vector(width-1 downto 0)
	);
end entity;

architecture mux_2x1_arch of mux_2x1 is
begin
	process(input1, input2, sel)
	begin
		if(sel = '1') then
			output <= input1;
		else
			output <= input2;
		end if;
	end process;
end mux_2x1_arch;