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
	
signal cinout : std_logic_vector(N - 1 downto 0);

begin 
	GEN: for i in 0 to N-1 generate
		FIRST: if i=0 generate	
			UO: full_adder port map(
				a_fa => a(i),
				b_fa => b(i),
				cin_fa => cin,
				cout_fa => cinout(i),
				s_fa => s(i)
			);
		end generate FIRST;
		
		OTHER_BITS: if i>0 generate
			UX: full_adder port map(
				a_fa => a(i),
				b_fa => b(i),
				cin_fa => cinout(i-1),
				cout_fa => cinout(i),
				s_fa => s(i)
			);
		end generate OTHER_BITS;	
	end generate GEN;	
	
	cout <= cinout(N-1);
	
end data_flow;			