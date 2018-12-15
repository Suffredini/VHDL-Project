library IEEE;
use IEEE.std_logic_1164.all;


entity 	CDMAReceiverWrap is
	port(
		fw_w	: in std_logic_vector(3 downto 0);
		led_w	: out std_logic_vector(3 downto 0);
		yq_w	: out std_logic_vector(5 downto 0);
		clk_w : in std_logic;
		rst_w : in std_logic
	);
end CDMAReceiverWrap;

architecture data_flow of CDMAReceiverWrap is
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
	
		wrap_CDMAReceiver: CDMAReceiver
		generic map(N => 4) -- N = log M (M numero di chip)
		port map(
			Xs_chip_CDMAR	=>	fw_w(0),
			C_chip_CDMAR	=>	fw_w(1),
			reset_CDMAR	=>	rst_w,
			clock_CDMAR => clk_w,
			S_CDMAR	=>	yq_w(0)
		);
	
		led_w <= fw_w;

end data_flow;