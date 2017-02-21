library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add is
  generic 
  (	width : positive := 8);
  
  port 
  (
    input1   : in  std_logic_vector(width-1 downto 0);
    input2   : in  std_logic_vector(width-1 downto 0);
    output   : out std_logic_vector(width-1 downto 0)
    );
end add;

architecture add_arch of add is
begin
	output <= std_logic_vector(unsigned(input1)+ unsigned(input2));
end add_arch;


