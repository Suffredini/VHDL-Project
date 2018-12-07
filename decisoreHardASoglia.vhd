library IEEE;
use IEEE.std_logic_1164.all;


entity  decisoreHardASoglia is
	port(
		S_chip_DHS	: in std_logic;
		clock_DHS	: in std_logic;
		reset_DHS	: in std_logic;
		S_DHS	: out std_logic
	);
end decisoreHardASoglia;



architecture data_flow of decisoreHardASoglia is

	function or_vector(slv : in std_logic_vector) return std_logic is
	  variable res_v : std_logic := '1';  -- Null slv vector will also return '1'
	begin
	  for i in slv'range loop
		res_v := res_v or slv(i);
	  end loop;
	  return res_v;
	end function;
	
	function nor_vector(slv : in std_logic_vector) return std_logic is
	  variable res_v : std_logic := '1';  -- Null slv vector will also return '1'
	begin
	  for i in slv'range loop
		res_v := res_v nor slv(i);
	  end loop;
	  return res_v;
	end function;
	
	constant N : integer := 4;
	
	component counter is
		generic (N: integer);	
		port(
			count_in	: in std_logic_vector(N - 1 downto 0);
			count_out	: out std_logic_vector(N - 1 downto 0);
			count_rst	: in std_logic;
			count_clk	: in std_logic
		);
	end component;
	
	component rippleCarryAdder is
		generic (N: integer);	
		port(
			a	: in std_logic_vector(N - 1 downto 0);
			b	: in std_logic_vector(N - 1 downto 0);
			s	: out std_logic_vector(N - 1 downto 0);
			cin	: in std_logic;
			cout	: out std_logic
		);
	end component;
	
	component D_flip_flop is
		generic (N : integer);
		port
		(
			clk : in std_logic;
			rst : in std_logic;
			d : in std_logic_vector(N-1 downto 0);
			q : out std_logic_vector(N-1 downto 0)
	    );
	end component;
	signal counter_A_out : std_logic_vector(N-1 downto 0);
	signal counter_A_in : std_logic_vector(N-1 downto 0);
	signal counter_B_out : std_logic_vector(N-1 downto 0);
	signal counter_B_in : std_logic_vector(N-1 downto 0);
	signal RCA_out : std_logic_vector(N-1 downto 0);
	signal S_tmp : std_logic_vector(0 downto 0);
	signal S_out: std_logic_vector(0 downto 0);
	signal RCA_cout : std_logic;
	signal reset_counter_A : std_logic;
	signal or_to_or : std_logic;
	signal clock_N : std_logic;
	--signal counter_B_nor : std_logic;
	
	begin 
		COUNTER_A: counter generic map(N => N) port map(
			count_in => counter_A_in,
			count_rst => reset_counter_A,
			count_clk => clock_DHS,
			count_out => counter_A_out
		);
		
		RIPPLE_CARRY_ADDER: rippleCarryAdder generic map(N => N) port map(
			s => RCA_out,
			a => counter_A_out,
			b => counter_A_in,--(others => '0'),
			cin => '0',--S_chip_DHS,
			cout => RCA_cout	
		); 
		
		COUNTER_B: counter generic map(N => N) port map(
			count_in => counter_B_in,
			count_rst => reset_DHS,
			count_clk => clock_DHS,
			count_out => counter_B_out
		);
		
		D_FLIP_FLOP_OUT: D_flip_flop generic map(N => 1) port map(
			d => S_tmp,
			q => S_out,			
			rst => reset_DHS,
			clk => clock_N			
		);
		
		counter_A_in <= (N - 1 downto 1 => '0') & S_chip_DHS;
		counter_B_in <= (N - 1 downto 1 => '0') & '1';
		
		S_tmp(0) <= RCA_cout or RCA_out(N-1);
		S_DHS <= S_out(0);
		
		process (counter_B_out) is
		begin	
			case (counter_B_out) is
				when "0001" => 
					clock_N <= '1';
					reset_counter_A <= reset_DHS;
				when "0000" => 
					clock_N <= '0';
					reset_counter_A <= '0';
				when others => 
					clock_N <= '0';
					reset_counter_A <= reset_DHS;
			end case;
		end process;


		--reset_counter_A <= reset_DHS and (not counter_B_nor);
		--clock_N <= clock_DHS and counter_B_nor;
		
end data_flow;		