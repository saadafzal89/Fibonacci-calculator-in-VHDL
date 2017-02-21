library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fib_tb is
end fib_tb;

architecture TB of fib_tb is
	
	constant TEST_WIDTH	: positive	:=8;
	
	signal clk		: std_logic	:= '0';
	signal rst		: std_logic	:= '0';
	signal go		: std_logic	:= '0';
	signal n 		: std_logic_vector(TEST_WIDTH-1 downto 0);
	signal done		: std_logic;
	signal output	: std_logic_vector(TEST_WIDTH-1 downto 0);
	
begin

	UUT	:entity work.fib(fsmd)
		generic map(width => TEST_WIDTH)
		port map (
			
			clk 	=> clk,
			rst		=> rst,
			go  	=> go,
			n 		=> n,
			output 	=> output,
			done 	=> done
		);
	
	clk <= not clk after 10 ns;
	
	process
	begin
		
		rst  <= '1';
		go   <= '0';
		--done <= '0';
		n <= (others => '0');
		
		wait for 100 ns;
		
		rst <= '0';
		for i in 0 to 2 loop
			wait until rising_edge(clk);
		end loop;
		
		--Checking for n = 5
		n <= std_logic_vector(to_unsigned(5, TEST_WIDTH));
		go <= '1';
		wait until rising_edge(clk);
		go <= '0';
		wait until done = '1';
		assert (output = std_logic_vector(to_unsigned(5, TEST_WIDTH)))
			report "Value of series is not correct";
		
		
		--Checking for n = 8
		n <= std_logic_vector(to_unsigned(8, TEST_WIDTH));
		go <= '1';
		wait until rising_edge(clk);
		go <= '0';
		wait until done = '1';
		assert (output = std_logic_vector(to_unsigned(21, TEST_WIDTH)))
			report "Value of series is not correct";
			
			
		--Checking for n = 12	
		n <= std_logic_vector(to_unsigned(12, TEST_WIDTH));
		go <= '1';
		wait until rising_edge(clk);
		go <= '0';
		wait until done = '1';
		assert (output = std_logic_vector(to_unsigned(144, TEST_WIDTH)))
			report "Value of series is not correct";
			
		--Checking for n = 1	
		n <= std_logic_vector(to_unsigned(1, TEST_WIDTH));
		go <= '1';
		wait until rising_edge(clk);
		go <= '0';
		wait until done = '1';
		assert (output = std_logic_vector(to_unsigned(1, TEST_WIDTH)))
			report "Value of series is not correct";
		
		wait;
	end process;
end TB;