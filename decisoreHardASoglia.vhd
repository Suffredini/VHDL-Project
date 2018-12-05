library IEEE;
use IEEE.std_logic_1164.all;


entity  decisoreHardASoglia is
	port(
		S_chip_DHS	: in std_logic;
		clock_DHS	: in std_logic;
		reset_DHS	: in std_logic;
		S_DHS	: out std_logic;
		clock_16_DHS : out std_logic
	);
end decisoreHardASoglia;

architecture data_flow of decisoreHardASoglia is
	
	component counter is
		generic (N: integer);	
		port(
			count_in	: in std_logic_vector(N - 1 downto 0);
			count_out	: out std_logic_vector(N - 1 downto 0);
			count_rst	: in std_logic;
			count_clk	: in std_logic
		);
	end component;

	
	signal counterBToAnd : std_logic_vector(4 downto 0);
	signal andToAnd : std_logic;
	signal counterAIn : std_logic_vector(4 downto 0);
	signal counterAOut : std_logic_vector(4 downto 0);
	signal reset_16_DHS : std_logic;
	
	begin 
		-- Tiente traccia di quanti S_chip a uno ho ricevuto
		COUNTER_A: counter generic map(N => 5) port map(
			count_in => counterAIn,
			count_rst => reset_16_DHS,
			count_clk => clock_DHS,
			count_out => counterAOut
		);
		
		-- Conta quanti chip ho ricevuto, serve per generare reset e clock ogni 16 clock
		COUNTER_B: counter generic map(N => 5) port map(
			count_in => "00001",
			count_rst => reset_16_DHS,
			count_clk => clock_DHS,
			count_out => counterBToAnd
		);
		
		-- Se il chip è 1 incremento il contatore A
		counterAIn <= "0000" & S_chip_DHS ;
		
		-- Devo aggiornare il dato in uscita quando il contatore ? uguale a 10000		
		andToAnd <= counterBToAnd(4);
			
		-- Clock 16 volte rallentato
		clock_16_DHS <= andToAnd;
		
		-- Se il 3° o il 4° bit sono alzati, decido che il bit stream vale 1
		S_DHS <= counterAOut(4) xor counterAOut(3);
		
		-- Resetto ogni 16 cilci di clock o quando arriva il reset generale		
		reset_16_DHS <= (not andToAnd) and reset_DHS;
end data_flow;		