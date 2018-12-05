library IEEE;
use IEEE.std_logic_1164.all;


entity  CDMAReceiver is
	port(
		Xs_chip_CDMAR	: in std_logic;
		C_chip_CDMAR	: in std_logic;
		reset_CDMAR	: in std_logic;
		clock_CDMAR : in std_logic;
		S_CDMAR	: out std_logic
	);
end CDMAReceiver;

architecture data_flow of CDMAReceiver is
	
	component decisoreHardASoglia is
		port(
			S_chip_DHS	: in std_logic;
			clock_DHS	: in std_logic;
			reset_DHS	: in std_logic;
			S_DHS	: out std_logic;
			clock_16_DHS : out std_logic
		);
	end component;

	component D_flip_flop is
		generic (N : integer);
		port		(
			clk : in std_logic;
			rst : in std_logic;
			d : in std_logic_vector(N-1 downto 0);
			q : out std_logic_vector(N-1 downto 0)
	    );
	end component;
	
	signal S_chip_CDMAR : std_logic;
	signal S_internal_CDMAR : std_logic_vector(0 downto 0);
	signal tmp : std_logic_vector(0 downto 0);
	signal clock_16_CDMAR : std_logic;
	
	begin 
		
		-- Decide il più probabile valore da presentare in uscita 
		-- e genera il clock_16 (1 ogni 16 cicli di clock)
		DHS: decisoreHardASoglia port map(
			S_chip_DHS	=> S_chip_CDMAR,
			clock_DHS	=> clock_CDMAR,
			reset_DHS	=> reset_CDMAR,
			S_DHS	=>	S_internal_CDMAR(0),
			clock_16_DHS => clock_16_CDMAR
		);
			
		-- Cambio il valore del segnale ogni 16 cicli di clock
		DFLIPFLOP: D_flip_flop generic map(N => 1) port map(
			d => S_internal_CDMAR,
			rst => reset_CDMAR,
			clk => clock_16_CDMAR,
			q => tmp
		); 
		S_CDMAR <=  tmp(0);
		
		-- Despreading
		S_chip_CDMAR <= Xs_chip_CDMAR xor C_chip_CDMAR;
		
		
		
end data_flow;		