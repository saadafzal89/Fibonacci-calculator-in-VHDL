library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fib_datapath is
	generic 
	(	width	:positive	:= 8);
	port
	(
		--clk & rst for register
		clk			:in std_logic;
		rst			:in std_logic;
		
		--control input
		i_sel		:in std_logic;
		x_sel		:in std_logic;
		y_sel		:in std_logic;
		i_ld		:in std_logic;
		x_ld		:in std_logic;
		y_ld		:in std_logic;
		n_ld		:in std_logic;
		result_ld	:in std_logic;
		
		--control output
		i_le_n		:out std_logic;
		
		--i/o
		n		:in std_logic_vector(width-1 downto 0);
		output 	:out std_logic_vector(width-1 downto 0)
	);
end fib_datapath;


architecture structure of fib_datapath is
	
	signal i_mux_out, x_mux_out, y_mux_out				:std_logic_vector(width-1 downto 0);
	signal i_reg_out, x_reg_out, y_reg_out, n_reg_out	:std_logic_vector(width-1 downto 0);
	signal add_out_1, add_out_2 						:std_logic_vector(width-1 downto 0);	
begin

	U_I_MUX	:entity work.mux_2x1
		generic map 
		(	width => width)
		port map
		(
			input1 	=> std_logic_vector(to_unsigned(3, width)),
			input2 	=> add_out_1,
			sel 	=> i_sel,
			output 	=> i_mux_out
		);
		
	U_X_MUX	:entity work.mux_2x1
		generic map 
		(	width => width)
		port map
		(
			input1 	=> std_logic_vector(to_unsigned(1, width)),
			input2 	=> y_reg_out,
			sel 	=> x_sel,
			output 	=> x_mux_out
		);
		
	U_Y_MUX	:entity work.mux_2x1
		generic map 
		(	width => width)
		port map
		(
			input1 	=> std_logic_vector(to_unsigned(1, width)),
			input2 	=> add_out_2,
			sel 	=> y_sel,
			output 	=> y_mux_out
		);
		
	U_I_REG : entity work.reg
        generic map
		(	width => width)
        port map 
		(
			clk    => clk,
			rst    => rst,
			en     => i_ld,
			input  => i_mux_out,
			output => i_reg_out
		);
		
	U_X_REG : entity work.reg
        generic map
		(	width => width)
        port map 
		(
			clk    => clk,
			rst    => rst,
			en     => x_ld,
			input  => x_mux_out,
			output => x_reg_out
		);
		
	U_Y_REG : entity work.reg
        generic map
		(	width => width)
        port map 
		(
			clk    => clk,
			rst    => rst,
			en     => y_ld,
			input  => y_mux_out,
			output => y_reg_out
		);
		
	U_N_REG : entity work.reg
        generic map
		(	width => width)
        port map 
		(
			clk    => clk,
			rst    => rst,
			en     => n_ld,
			input  => n,
			output => n_reg_out
		);
		
	U_COMP : entity work.comp
        generic map 
		(	width => width)
        port map 
		(	
			input1 => i_reg_out,
            input2 => n_reg_out,
			ne  => i_le_n
		);
	
	U_ADD1 : entity work.add
        generic map 
		(	width => width)
        port map 
		(	
			input1	=> i_reg_out,
			input2  => std_logic_vector(to_unsigned(1, width)),
			output 	=> add_out_1
		);
	
	U_ADD2 : entity work.add
        generic map 
		(	width => width)
        port map 
		(	
			input1	=> x_reg_out,
			input2  => y_reg_out,
			output 	=> add_out_2
		);
		
	U_RESULT_REG : entity work.reg
        generic map
		(	width => width)
        port map 
		(
			clk    => clk,
			rst    => rst,
			en     => result_ld,
			input  => y_reg_out,
			output => output
		);

end structure;