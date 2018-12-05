library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity D_flip_flop is
   generic (N : integer);
   port (
      clk : in std_logic;
      rst : in std_logic;      
      d : in std_logic_vector(N-1 downto 0);
      q : out std_logic_vector(N-1 downto 0)
   );
end D_flip_flop;
 
architecture Behavioral of D_flip_flop is

begin
   process (clk, rst) is
   begin
      if rising_edge(clk) then  
        if (rst='0') then   
            q <= (others => '0');
        else	
			q <= d;
		end if;
      end if;
   end process;
end architecture Behavioral;