library IEEE;
use IEEE.std_logic_1164.all;

entity rippleCarryAdder is
	generic (N: integer);	
	port(
		a	: in std_logic_vector(N - 1 downto 0);
		b	: in std_logic_vector(N - 1 downto 0);
		s	: out std_logic_vector(N - 1 downto 0);
		cin	: in std_logic;
		cout	: out std_logic
	);
end rippleCarryAdder;

architecture data_flow of rippleCarryAdder is

	component full_adder is  	
		port(		
			a_fa	: in std_logic;
			b_fa       : in std_logic;  
			cin_fa     : in std_logic;   
	        s_fa	: out std_logic;
			cout_fa	: out std_logic
	       );
	end component;
	
signal cinout : std_logic_vector(N downto 0);

begin 
		RIPPLE_GEN:for i in 0 to N - 1  generate
			
			UX: full_adder port map(
				a_fa => a(i),
				b_fa => b(i),
				cin_fa => cinout(i),
				cout_fa => cinout(i+1),
				s_fa => s(i)
			);
		end generate;	

	cinout(0) <= cin;
	cout <= cinout(N);
	
end data_flow;			