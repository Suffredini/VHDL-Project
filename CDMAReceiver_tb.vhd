library IEEE;
use IEEE.std_logic_1164.all;

entity CDMAReceiver_tb is   -- The testbench has no interface, so it is an empty entity (Be careful: the keyword "is" was missing in the code written in class).
end CDMAReceiver_tb;

architecture bhv of CDMAReceiver_tb is -- Testbench architecture declaration
        -----------------------------------------------------------------------------------
        -- Testbench constants
        -----------------------------------------------------------------------------------
	constant T_CLK   : time := 10 ns; -- Clock period
	constant T_RESET : time := 25 ns; -- Period before the reset deassertion
	constant N : integer := 4;
	-----------------------------------------------------------------------------------
        -- Testbench signals
        -----------------------------------------------------------------------------------
	signal clk_tb : std_logic := '0'; -- clock signal, intialized to '0' 
	signal rst_tb  : std_logic := '0'; -- reset signal
	signal bitStream_tb   : std_logic;        -- d signal to connect to the d port of the component
	signal codeWord_tb : std_logic;
	signal chipStream_tb   : std_logic;
	signal end_sim : std_logic := '1'; -- signal to use to stop the simulation when there is nothing else to test
	signal count16 : std_logic := '0'; -- DEBUG VISIVO
        -----------------------------------------------------------------------------------
        -- Component to test (DUT) declaration
        -----------------------------------------------------------------------------------
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
	
	  clk_tb <= (not(clk_tb) and end_sim) after T_CLK / 2;  -- The clock toggles after T_CLK / 2 when end_sim is high. When end_sim is forced low, the clock stops toggling and the simulation ends.
	  rst_tb <= '1' after T_RESET; -- Deasserting the reset after T_RESET nanosecods (remember: the reset is active low).
	  
	  test_CDMAReceiver: CDMAReceiver	  -- Shift register instantiation
			generic map(N => N) -- N = log M (M numero di chip)
			port map(
				Xs_chip_CDMAR	=>	chipStream_tb,
				C_chip_CDMAR	=>	codeWord_tb,
				reset_CDMAR	=>	rst_tb,
				clock_CDMAR => clk_tb,
				S_CDMAR	=>	bitStream_tb
	        );
	  
	  d_process: process(clk_tb, rst_tb) -- process used to make the testbench signals change synchronously with the rising edge of the clock
		variable t : integer := 0; -- variable used to count the clock cycle after the reset
	  begin
	    if(rst_tb = '0') then
			chipStream_tb <= '0';
			codeWord_tb <= '0';
			count16 <= '1';
			t := 0;
		elsif(rising_edge(clk_tb)) then
		  case(t) is   -- specifying the input d_tb and end_sim depending on the value of t ( and so on the number of the passed clock cycles).
			-- Ora invio 1, un bit errato
			when 1 => 
				chipStream_tb <= '0';
				codeWord_tb <= '0';
				count16 <= '1';
				
			when 2 => 
				chipStream_tb <= '0';
				codeWord_tb <= '0'; 

			when 3 => 
				chipStream_tb <= '0';
				codeWord_tb <= '0';

			when 4 => 
				chipStream_tb <= '0';
				codeWord_tb <= '0';

			when 5 => 
				chipStream_tb <= '0';
				codeWord_tb <= '0';
	
			when 6 => 
				chipStream_tb <= '0';
				codeWord_tb <= '0';

			when 7 => 
				chipStream_tb <= '0';
				codeWord_tb <= '0';

			when 8 => 
				chipStream_tb <= '1';
				codeWord_tb <= '0';

			when 9 => 
				chipStream_tb <= '1';
				codeWord_tb <= '0';
		
			when 10 => 
				chipStream_tb <= '1';
				codeWord_tb <= '0';
		
			when 11 => 
				chipStream_tb <= '1';
				codeWord_tb <= '0';
	
			when 12 => 
				chipStream_tb <= '1';
				codeWord_tb <= '0';

			when 13 => 
				chipStream_tb <= '1';
				codeWord_tb <= '0';
	
			when 14 => 
				chipStream_tb <= '1';
				codeWord_tb <= '0';

			when 15 => 
				chipStream_tb <= '1';
				codeWord_tb <= '0';
	
				
			--- Ora invio 0, qualche bit è errato
			when 16 => 
				chipStream_tb <= '1';
				codeWord_tb <= '0';
				count16 <= '0';
			when 17 => 
				chipStream_tb <= '0';
				codeWord_tb <= '0';

			when 18 => 
				chipStream_tb <= '0';
				codeWord_tb <= '0';			

			when 19 => 
				chipStream_tb <= '0';
				codeWord_tb <= '0';

			when 20 => 
				chipStream_tb <= '0';
				codeWord_tb <= '0';

			when 21 => 
				chipStream_tb <= '0';
				codeWord_tb <= '0';

			when 22 => 
				chipStream_tb <= '0';
				codeWord_tb <= '0';

			when 23 => 
				chipStream_tb <= '0';
				codeWord_tb <= '0';

			when 24 => 
				chipStream_tb <= '0';
				codeWord_tb <= '0';

			when 25 => 
				chipStream_tb <= '0';
				codeWord_tb <= '0';

			when 26 => 
				chipStream_tb <= '0';
				codeWord_tb <= '0';
	
			when 27 => 
				chipStream_tb <= '0';
				codeWord_tb <= '0';
			
			when 28 => 
				chipStream_tb <= '0';
				codeWord_tb <= '0';
	
			when 29 => 
				chipStream_tb <= '0';
				codeWord_tb <= '0';

			when 30 => 
				chipStream_tb <= '0';
				codeWord_tb <= '0';

			when 31 => 
				chipStream_tb <= '0';
				codeWord_tb <= '0';
			-- 3
			
			when 32 => 
				chipStream_tb <= '1';
				codeWord_tb <= '0';
				count16 <= '1';
			when 33 => 
				chipStream_tb <= '1';
				codeWord_tb <= '0';
			
			when 34 => 
				chipStream_tb <= '1';
				codeWord_tb <= '0';
			
			when 35 => 
				chipStream_tb <= '1';
				codeWord_tb <= '0';
			
			when 36 => 
				chipStream_tb <= '1';
				codeWord_tb <= '0';
				
			when 37 => end_sim <= '0'; -- This command stops the simulation when t = 10
            when others => null; -- Specifying that nothing happens in the other cases 
			
		  end case;
		  t := t + 1; -- the variable is updated exactly here (try to move this statement before the "case(t) is" one and watch the difference in the simulation)
		end if;
	  end process;
	
end bhv;