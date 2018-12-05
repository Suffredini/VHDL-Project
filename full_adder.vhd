library ieee;
    use ieee.std_logic_1164.all;


    entity full_adder is
        port( -- Input of the full-adder
                a_fa   : in std_logic;
                -- Input of the full-adder
                b_fa   : in std_logic;
                -- Carry input 
                cin_fa : in std_logic;
                -- Output of the full-adder
                s_fa   : out std_logic;
                -- Carry output
                cout_fa : out std_logic
            );
    end full_adder;
   architecture data_flow of full_adder is
   
   begin
   
      s_fa   <= a_fa xor b_fa xor cin_fa;
      
      cout_fa <= (a_fa and b_fa) or (b_fa and cin_fa) or (cin_fa and a_fa);
   
   end data_flow;
    