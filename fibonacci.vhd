library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fib is
	generic
	(	width:	positive:=	8);
	port
	(
		rst, clk	: in std_logic;
		n			: in std_logic_vector(width-1 downto 0);
		go			: in std_logic;
		done		: out std_logic;
		output		: out std_logic_vector(width-1 downto 0)
	);
end entity;


architecture fsmd of fib is
	type state_type is (S_WAIT, S_INIT, S_LOOP_COND, S_ELSE, S_DONE);
	signal state:	state_type;
	signal regN, i, x, y	: std_logic_vector(width -1 downto 0);
	
begin
	process (clk, rst)
	variable temp:	unsigned (width-1 downto 0);
	begin
		if(rst ='1') then
			done <= '0';
			output <= (others => '0');
			regN <= std_logic_vector(to_unsigned(0, WIDTH));
			x <= std_logic_vector(to_unsigned(0, WIDTH));
			y <= std_logic_vector(to_unsigned(0, WIDTH));
			i <= std_logic_vector(to_unsigned(0, WIDTH));
		
		elsif (clk'event and clk ='1') then
			case state is 
				when S_WAIT =>
				if(go='1') then
					state <= S_INIT;
				end if;
			 
				when S_INIT =>
				done <= '0';
				regN <= n;
				i <= std_logic_vector(to_unsigned(3, WIDTH));
				x <= std_logic_vector(to_unsigned(1, WIDTH));
				y <= std_logic_vector(to_unsigned(1, WIDTH));
				state <= S_LOOP_COND;
				
				when S_LOOP_COND =>
				if (i>regN) then
					state <= S_DONE;
				elsif (i<=regN) then
					state <= S_ELSE;
				end if;
				 
				when S_ELSE =>
				temp := unsigned(x) + unsigned(y);
				x <= y;
				y <= std_logic_vector(temp);
				i <= std_logic_vector(unsigned(i) + 1);
				state <= S_LOOP_COND;
					
				when S_DONE =>
				output <= y;
				done <= '1';
				if(go='0') then
					state <= S_WAIT;
				end if;
				
				when others => null;
				
			end case;
		end if;
	end process;
end fsmd;



architecture fsm_plus_d of fib is

	signal i_sel	 :std_logic;
	signal x_sel	 :std_logic;
	signal y_sel	 :std_logic;
	signal i_ld		 :std_logic;
	signal x_ld		 :std_logic;
	signal y_ld		 :std_logic;
	signal n_ld		 :std_logic;
	signal result_ld :std_logic;
	signal i_le_n	 :std_logic;
	
begin

	U_CTRL : entity work.fib_control
        port map 
		(
			clk       => clk,
			rst       => rst,
			go        => go,
			done      => done,
			i_sel	  => i_sel,
			x_sel     => x_sel,
			y_sel     => y_sel,
			i_ld	  => i_ld,
			x_ld      => x_ld,
			y_ld      => y_ld,
			n_ld	  => n_ld,
			result_ld => result_ld,
			i_le_n    => i_le_n
		);

    U_DP : entity work.fib_datapath
        generic map (width => width)
        port map 
		(
			clk       => clk,
            rst       => rst,
            i_sel	  => i_sel,
			x_sel     => x_sel,
			y_sel     => y_sel,
			i_ld	  => i_ld,
			x_ld      => x_ld,
			y_ld      => y_ld,
			n_ld	  => n_ld,
			result_ld => result_ld,
			i_le_n    => i_le_n,
            n         => n,
            output    => output
		);
end fsm_plus_d;