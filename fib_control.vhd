library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fib_control is 
port
(
	clk	:in std_logic;
	rst	:in std_logic;
	go	:in std_logic;
	done:out std_logic;
	
	--control input
	i_le_n		:in std_logic;
	
	--control outputs
	i_sel		:out std_logic;
	x_sel		:out std_logic;
	y_sel		:out std_logic;
	i_ld		:out std_logic;
	x_ld		:out std_logic;
	y_ld		:out std_logic;
	n_ld		:out std_logic;
	result_ld	:out std_logic
	             
);
end fib_control;


architecture FSM of fib_control is

	type STATE_TYPE is (S_WAIT, S_RESTART, S_INIT, S_LOOP_COND, S_ELSE, S_DONE, S_WHILE_GO_EQ_1);
	signal state, next_state	: STATE_TYPE;

begin
	process(clk, rst)
	begin
		if(rst = '1') then
			state <= S_WAIT;
		elsif(clk'event and clk = '1') then
			state <= next_state;
		end if;
	end process;

	process(state, go, i_le_n)
	begin
		i_sel	<='0';
		x_sel	<='0';	
		y_sel	<='0';	
		i_ld	<='0';
		x_ld	<='0';
		y_ld	<='0';
		n_ld	<='0';
		result_ld <= '0';
		done	<='0';	
		next_state	<=state;
		
		case state is
		
			when S_WAIT =>
				if(go='1') then
					next_state <= S_INIT;
				end if;
				
			when s_RESTART =>
				done <= '1';
				if(go = '1') then
					done <= '0';
					next_state <= S_INIT;
				end if;
				
			when S_INIT =>
				i_sel	<= '1';
				x_sel	<= '1';
				y_sel	<= '1';
				i_ld	<= '1';
				x_ld	<= '1';
				y_ld	<= '1';
				n_ld	<= '1';
				next_state <= S_LOOP_COND;
			
			
			when S_LOOP_COND =>
				if(i_le_n='1') then
				    --result_ld <= '1';
					next_state <= S_DONE;
				else
					next_state <= S_ELSE;
				end if;
				
				
			when S_ELSE =>
				i_sel	<='0';
				x_sel	<='0';	
				y_sel	<='0';	
				i_ld	<= '1';
				x_ld	<= '1';
				y_ld	<= '1';
				--n_ld	<= '1';
				next_state <= S_LOOP_COND;
				
				
			when S_DONE =>
				result_ld <= '1';
				done <= '1';
				if(go='0') then
					next_state <= S_WHILE_GO_EQ_1;
				end if;
					
			
			when S_WHILE_GO_EQ_1 =>
				done <= '1';
				if(go='0') then
					next_state <= S_RESTART;
				end if;
				
			when others => null;
		end case;
	end process;
end FSM;