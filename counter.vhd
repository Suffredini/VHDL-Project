library IEEE;
use IEEE.std_logic_1164.all;


entity counter is
	generic (N: integer);
	
	port(
		count_in	: in std_logic_vector(N - 1 downto 0);
		count_out	: out std_logic_vector(N - 1 downto 0);
		count_rst	: in std_logic;
		count_clk	: in std_logic
	);
end counter;

architecture data_flow of counter is
	
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
			q : out std_logic_vector(N-1 downto 0);
			en : std_logic
	    );
	end component;
	
	
signal internal : std_logic_vector(N - 1 downto 0);
signal qc : std_logic_vector(N - 1 downto 0);

begin 
	
	-- Sum new value with value keep by D_flip_flop
	RIPPLE: rippleCarryAdder generic map(N => N) port map(
		s => internal,
		a => count_in,
		b => qc,
		cin => '0'
	);	
	
	-- Keep actual value
	DFF: D_flip_flop generic map(N => N) port map(		
		clk => count_clk,
		rst => count_rst,
		d => internal,
		q => qc,
		en => '1'
	);
	
	-- Connect D_flip_flops output with counter output
	count_out <= qc;		
end data_flow;