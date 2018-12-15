library IEEE;
use IEEE.std_logic_1164.all;

entity CDMAReceiver_tb is
end CDMAReceiver_tb;

architecture bhv of CDMAReceiver_tb is
	-- Declare constants
	constant T_CLK   : time := 10 ns; -- Clock period
	constant T_RESET : time := 25 ns; -- Period before the reset deassertion
	constant N : integer := 4;

	--Declare signals
	signal clk_tb : std_logic := '0';
	signal rst_tb  : std_logic := '0';
	signal bitStream_tb   : std_logic;
	signal codeWord_tb : std_logic;
	signal chipStream_tb   : std_logic;
	signal end_sim : std_logic := '1';

	
	--Declare component
	component CDMAReceiver is
	generic (N: integer);
	port(
		Xs_chip_CDMAR	: in std_logic;
		C_chip_CDMAR	: in std_logic;
		reset_CDMAR	: in std_logic;
		clock_CDMAR : in std_logic;
		S_CDMAR	: out std_logic
	);
	end component;

	
	begin	
		-- The clock toggles after T_CLK / 2 when end_sim is high. When end_sim is forced low, the clock stops toggling and the simulation ends.
		clk_tb <= (not(clk_tb) and end_sim) after T_CLK / 2;  
		  
		-- Deasserting the reset after T_RESET nanosecods (remember: the reset is active low).
		rst_tb <= '1' after T_RESET;
	  
		test_CDMAReceiver: CDMAReceiver
			generic map(N => N) -- N = log M (M numero di chip)
			port map(
				Xs_chip_CDMAR	=>	chipStream_tb,
				C_chip_CDMAR	=>	codeWord_tb,
				reset_CDMAR	=>	rst_tb,
				clock_CDMAR => clk_tb,
				S_CDMAR	=>	bitStream_tb
			);
		
		-- process used to make the testbench signals change synchronously with the rising edge of the clock
		d_process: process(clk_tb, rst_tb) 
		
		-- variable used to count the clock cycle after the reset
		variable t : integer := 0; 
		
		begin
			if(rst_tb = '0') then
				chipStream_tb <= '0';
				codeWord_tb <= '0';
			elsif(rising_edge(clk_tb)) then
				if(t = 50) then
					end_sim <= '0';
				elsif(t < 1 ) then
					chipStream_tb <= '0';
					codeWord_tb <= '1';
				
				elsif (t < 16) then 
					chipStream_tb <= '0';
					codeWord_tb <= '1';

				elsif (t < 28) then
					chipStream_tb <= '0';
					codeWord_tb <= '0';

				elsif ( t<32) then
					chipStream_tb <= '0';
					codeWord_tb <= '1';
				else
					chipStream_tb <= '0';
					codeWord_tb <= '0';
				end if;
				
				-- the variable is updated exactly here (try to move this statement before the "case(t) is" one and watch the difference in the simulation)
				t := t + 1; 
			end if;
	  end process;
	
end bhv;