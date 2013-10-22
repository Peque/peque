library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity rvb is
    port(   horl : 		in std_logic;
				video :		in std_logic;
            couleur :   in std_logic_vector(0 to 2):="000";
            rouge : 		out std_logic_vector(0 to 9):="0000000000";
				vert : 		out std_logic_vector(0 to 9):="0000000000";
				bleu : 		out std_logic_vector(0 to 9):="0000000000");
end rvb;

architecture A of rvb is
	begin

		process(horl)
		begin
        if(horl'event and horl='1') then 
				if(video='1') then
				
					rouge<="1111111111";
					vert<="1111111111";
					bleu<="1111111111";
					
					if(couleur="000") then
					rouge<="0000000000";
					vert<="0000000000";
					bleu<="1111111111";
					end if;
					
					if(couleur="010") then
					rouge<="1111111111";
					vert<="0000000000";
					bleu<="0000000000";
					end if;
					
					if(couleur="011") then
					rouge<="0000000000";
					vert<="1111111111";
					bleu<="0000000000";
					end if;
					
				else
					rouge<="0000000000";
					vert<="0000000000";
					bleu<="0000000000";
				end if;
        end if;
		end process;
end A;