library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comp is
    generic 
	(	width : positive := 8);
    port 
	(
        input1	: in  std_logic_vector(width-1 downto 0);
        input2	: in  std_logic_vector(width-1 downto 0);
        --lt  	: out std_logic;
        ne		: out std_logic
        );
end comp;


architecture comp_arch of comp is
begin
    process(input1, input2)
    begin
        --lt <= '0';
        --ne <= '0';

        if (unsigned(input1) <= unsigned(input2)) then
            ne <= '0';
			
        else
            ne <= '1';
        end if;
    end process;
end comp_arch;



