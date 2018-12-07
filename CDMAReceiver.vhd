library IEEE;
use IEEE.std_logic_1164.all;


entity  CDMAReceiver is
	generic (N: integer);
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
		generic (N : integer);
		port(
			S_chip_DHS	: in std_logic;
			clock_DHS	: in std_logic;
			reset_DHS	: in std_logic;
			S_DHS	: out std_logic
		);
	end component;
	
	signal S_chip_CDMAR : std_logic;
	signal tmp : std_logic_vector(0 downto 0);
	
	begin 
		
		-- Decide il più probabile valore da presentare in uscita 
		-- e genera il clock_16 (1 ogni 16 cicli di clock)
		DHS: decisoreHardASoglia  generic map(N => N) port map(
			S_chip_DHS	=> S_chip_CDMAR,
			clock_DHS	=> clock_CDMAR,
			reset_DHS	=> reset_CDMAR,
			S_DHS	=>	S_CDMAR
		);
			
		-- Despreading
		S_chip_CDMAR <= Xs_chip_CDMAR xor C_chip_CDMAR;
		
end data_flow;		