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
			q : out std_logic_vector(N-1 downto 0)
	    );
	end component;
	
	
signal internal : std_logic_vector(N - 1 downto 0);
signal qc : std_logic_vector(N - 1 downto 0);

begin 
	
	RIPPLE: rippleCarryAdder generic map(N => N) port map(
		s => internal,
		a => count_in,
		--b => count_out,
		b => qc,
		cin => '0'
		--cout => '-'	
		);
	
	
	DFF: D_flip_flop generic map(N => N) port map(
		d => internal,
		rst => count_rst,
		clk => count_clk,
		--count_out => q
		q => qc
	);
	
	count_out <= qc;
		
end data_flow;
		
			
			