library IEEE;
use IEEE.std_logic_1164.all;

entity decisoreHardASoglia_tb is   -- The testbench has no interface, so it is an empty entity (Be careful: the keyword "is" was missing in the code written in class).
end decisoreHardASoglia_tb;

architecture bhv of decisoreHardASoglia_tb is -- Testbench architecture declaration
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
	signal S_chip_tb   : std_logic;        -- d signal to connect to the d port of the component
	signal clock_16_tb : std_logic;
	signal S_tb   : std_logic;
	signal end_sim : std_logic := '1'; -- signal to use to stop the simulation when there is nothing else to test
	
        -----------------------------------------------------------------------------------
        -- Component to test (DUT) declaration
        -----------------------------------------------------------------------------------
        component decisoreHardASoglia is
		--generic (N: integer);
		port(
			S_chip_DHS	: in std_logic;
			clock_DHS	: in std_logic;
			reset_DHS	: in std_logic;
			S_DHS	: out std_logic
		);
		end component;
	
	
	begin
	
	  clk_tb <= (not(clk_tb) and end_sim) after T_CLK / 2;  -- The clock toggles after T_CLK / 2 when end_sim is high. When end_sim is forced low, the clock stops toggling and the simulation ends.
	  rst_tb <= '1' after T_RESET; -- Deasserting the reset after T_RESET nanosecods (remember: the reset is active low).
	  
	  test_DHS1: decisoreHardASoglia	  -- Shift register instantiation
            --  generic map(N) -- It is necessary to specify the number of bits of the shift register (3 in this case). Try to change and watch the difference in the simulation.
			port map(
				S_chip_DHS	=> S_chip_tb,
				clock_DHS	=> clk_tb ,
				reset_DHS	=> rst_tb,
				S_DHS	 => S_tb
	        );
	  
	  d_process: process(clk_tb, rst_tb) -- process used to make the testbench signals change synchronously with the rising edge of the clock
		variable t : integer := 0; -- variable used to count the clock cycle after the reset
	  begin
	    if(rst_tb = '0') then
			S_chip_tb <= '1';
		elsif(rising_edge(clk_tb)) then
		  case(t) is   -- specifying the input d_tb and end_sim depending on the value of t ( and so on the number of the passed clock cycles).
			
			when 1 => S_chip_tb <= '0';
				
			when 2 => S_chip_tb <= '0';
				
			when 3 => S_chip_tb <= '0';
			
			when 4 => S_chip_tb <= '0';
			
			when 5 => S_chip_tb <= '0';
			
			when 6 => S_chip_tb <= '0';
			
			when 7 => S_chip_tb <= '0';
			
			when 8 => S_chip_tb <= '0';
			
			when 9 => S_chip_tb <= '1';
			
			when 10 => S_chip_tb <= '1';
			
			when 11 => S_chip_tb <= '1';
			
			when 12 => S_chip_tb <= '1';
			
			when 13 => S_chip_tb <= '1';
			
			when 14 => S_chip_tb <= '1';
			
			when 15 => S_chip_tb <= '1';
			-- nuovo bit
			when 16 => S_chip_tb <= '1';
			
			when 17 => S_chip_tb <= '0';
			
			when 18 => S_chip_tb <= '1';
				
			when 19 => end_sim <= '0'; -- This command stops the simulation when t = 10
            when others => null; -- Specifying that nothing happens in the other cases 
			
		  end case;
		  t := t + 1; -- the variable is updated exactly here (try to move this statement before the "case(t) is" one and watch the difference in the simulation)
		end if;
	  end process;
	
end bhv;